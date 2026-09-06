#!/usr/bin/env python3
"""Cross-platform installer for this dotfiles repo.

Stdlib only, on purpose -- this runs on freshly installed machines before any
package manager has been used. Do not add third-party dependencies.

setup.sh is a thin POSIX sh bootstrap that finds Python and execs this.
Running `stow <package>` by hand remains fully supported; this script is a
convenience wrapper around the same operations.
"""

import argparse
import json
import os
import platform
import re
import shutil
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
MANIFEST = REPO / "packages" / "manifest.json"
STOW_LIST = REPO / "all_stowed_files.txt"

# stow reports conflicts as:
#   * cannot stow <src> over existing target <target> since neither a link nor
#     a directory and --adopt not specified
#   * existing target is not owned by stow: <target>
CONFLICT_RE = re.compile(
    r"cannot stow .+? over existing target (?P<target>.+?) since"
    r"|existing target is not owned by stow:\s*(?P<target2>.+)"
)

DRY_RUN = False


# ─── output ──────────────────────────────────────────────────────────────

def info(msg):
    print("\033[34m::\033[0m %s" % msg)


def warn(msg):
    print("\033[33m!!\033[0m %s" % msg, file=sys.stderr)


def die(msg, code=1):
    print("\033[31mxx\033[0m %s" % msg, file=sys.stderr)
    sys.exit(code)


def run(cmd, check=True, capture=False, timeout=None):
    """Run a command, or just print it under --dry-run."""
    printable = " ".join(cmd)
    if DRY_RUN:
        print("   would run: %s" % printable)
        return subprocess.CompletedProcess(cmd, 0, "", "")
    print("   %s" % printable)
    return subprocess.run(
        cmd,
        check=check,
        text=True,
        timeout=timeout,
        stdout=subprocess.PIPE if capture else None,
        stderr=subprocess.PIPE if capture else None,
    )


def probe(cmd):
    """Run a query command quietly; return True if it succeeded.

    Always executes, even under --dry-run: validation is read-only and its
    result is what makes a dry run worth reading.
    """
    try:
        r = subprocess.run(
            cmd,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=120,
        )
        return r.returncode == 0
    except (OSError, subprocess.SubprocessError):
        return False


# ─── phase 1: detect ─────────────────────────────────────────────────────

def load_manifest():
    if not MANIFEST.exists():
        die("manifest not found: %s" % MANIFEST)
    with MANIFEST.open() as fh:
        return json.load(fh)


def detect_manager(manifest, override=None):
    """Resolve which package manager key applies to this machine."""
    managers = manifest["managers"]
    if override:
        if override not in managers:
            die("unknown manager %r; known: %s"
                % (override, ", ".join(sorted(managers))))
        return override

    uname = platform.system()
    # Match on OS first so a Linux box with brew installed is not mistaken
    # for macOS, then on which manager binary actually exists.
    candidates = [k for k, m in managers.items() if m.get("os") == uname]
    for key in candidates:
        if shutil.which(managers[key]["detect"]):
            return key

    die("could not detect a supported package manager on %s (looked for: %s).\n"
        "   Pass --manager to force one, or --skip-packages to stow only."
        % (uname, ", ".join(managers[k]["detect"] for k in candidates) or "none"))


# ─── phase 2: resolve + validate ─────────────────────────────────────────

class Resolved:
    def __init__(self, pkg, name, aur, unverified):
        self.id = pkg["id"]
        self.name = name
        self.aur = aur
        self.unverified = unverified


def resolve(manifest, manager, want_desktop):
    """Map manifest entries to concrete package names for this manager.

    Returns (resolved, skipped, unmapped).
    """
    resolved, skipped, unmapped = [], [], []

    for pkg in manifest["packages"]:
        group = pkg.get("group", "core")
        if group == "desktop" and not want_desktop:
            continue
        # A desktop entry pinned to specific managers is never installed
        # elsewhere, even with --desktop.
        allowed = pkg.get("os")
        if allowed and manager not in allowed:
            skipped.append((pkg["id"], "not available on %s" % manager))
            continue

        overrides = pkg.get("overrides", {})
        if manager in overrides:
            name = overrides[manager]
            if name is None:
                skipped.append((pkg["id"], "no package on %s" % manager))
                continue
        else:
            name = pkg.get("name")

        if not name:
            unmapped.append(pkg["id"])
            continue

        resolved.append(Resolved(
            pkg,
            name,
            bool(pkg.get("aur")) and manager == "arch",
            manager in pkg.get("unverified", []),
        ))

    return resolved, skipped, unmapped


def validate(manifest, manager, resolved):
    """Check every resolved name against the local package manager.

    Collects all failures and reports them together, so a package list with
    several bad names takes one round-trip to fix rather than one per name.
    """
    cfg = manifest["managers"][manager]
    base = cfg["query"]
    aur_query = cfg.get("aur_query")

    if not shutil.which(base[0]):
        warn("%s not on PATH; skipping name validation" % base[0])
        return []

    bad = []
    info("Validating %d package names against %s..." % (len(resolved), base[0]))
    for r in resolved:
        query = aur_query if (r.aur and aur_query and shutil.which(aur_query[0])) else base
        if not probe(list(query) + [r.name]):
            bad.append(r)
    return bad


# ─── phase 3: install ────────────────────────────────────────────────────

def install_packages(manifest, manager, resolved):
    if not resolved:
        info("Nothing to install.")
        return

    cfg = manifest["managers"][manager]
    needs_aur = any(r.aur for r in resolved)

    cmd = list(cfg["install"])
    if manager == "arch":
        helper = cfg.get("helper")
        if needs_aur:
            if not shutil.which(helper):
                die("%d package(s) need the AUR but %s is not installed.\n"
                    "   Install it first, or re-run without --desktop."
                    % (sum(1 for r in resolved if r.aur), helper))
        elif not shutil.which(helper):
            # No AUR entries in scope, so plain pacman is enough.
            cmd = list(cfg["install_no_aur"])

    names = sorted(r.name for r in resolved)
    info("Installing %d package(s) with %s..." % (len(names), cmd[0]))
    run(cmd + names)


# ─── phase 4: submodules ─────────────────────────────────────────────────

def init_submodules():
    """Fetch oh-my-zsh, ohmytmux, powerlevel10k and zsh-vi-mode.

    All four are submodules, so this is the whole of the shell setup -- there
    is nothing to clone by hand.
    """
    if not shutil.which("git"):
        warn("git not found; skipping submodule init")
        return
    info("Initialising git submodules...")
    run(["git", "-C", str(REPO), "submodule", "update", "--init", "--recursive"],
        check=False)


VIM_PLUG_URL = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"


def install_vim_plug():
    """Fetch vim-plug, which vim/.vimrc calls on its first line.

    No package manager ships it and it has to land in ~/.vim/autoload for vim
    to find it, so it is downloaded rather than installed. Without it vim
    errors out on every startup.
    """
    dest = Path.home() / ".vim" / "autoload" / "plug.vim"
    if dest.exists():
        info("vim-plug already installed.")
    else:
        info("Installing vim-plug...")
        if shutil.which("curl"):
            cmd = ["curl", "-fsSLo", str(dest), "--create-dirs", VIM_PLUG_URL]
        elif shutil.which("wget"):
            if not DRY_RUN:
                dest.parent.mkdir(parents=True, exist_ok=True)
            cmd = ["wget", "-qO", str(dest), VIM_PLUG_URL]
        else:
            warn("neither curl nor wget found; skipping vim-plug")
            return
        try:
            run(cmd, timeout=120)
        except (subprocess.SubprocessError, OSError) as exc:
            warn("could not fetch vim-plug (%s); vim will error until it is "
                 "installed by hand" % exc)
            return

    if not shutil.which("vim"):
        return
    # Fetch the plugins .vimrc declares. Silent ex mode so it cannot stop on a
    # prompt; a failure here is not fatal, since :PlugInstall can be re-run.
    info("Installing vim plugins...")
    try:
        run(["vim", "-es", "-u", str(Path.home() / ".vimrc"), "-i", "NONE",
             "-c", "PlugInstall --sync", "-c", "qa"],
            check=False, timeout=300)
    except (subprocess.SubprocessError, OSError) as exc:
        warn("vim PlugInstall did not finish (%s); run :PlugInstall in vim"
             % exc)


# ─── phase 5: stow ───────────────────────────────────────────────────────

def stow_packages(only=None):
    """Stow each package listed in all_stowed_files.txt, backing up conflicts.

    Conflicts come from stow itself rather than from probing ~/.config: a
    package need not live there at all (zsh owns ~/.zshrc), so guessing the
    target path both misses conflicts and invents ones that do not exist.
    """
    if not shutil.which("stow"):
        die("stow is not installed -- it is the whole point of this repo")
    if not STOW_LIST.exists():
        die("missing %s" % STOW_LIST)

    packages = [
        line.strip()
        for line in STOW_LIST.read_text().splitlines()
        if line.strip() and not line.startswith("#")
    ]
    if only:
        unknown = sorted(set(only) - set(packages))
        if unknown:
            warn("not in %s: %s" % (STOW_LIST.name, ", ".join(unknown)))
        packages = [p for p in packages if p in set(only)]

    for pkg in packages:
        d = REPO / pkg
        if not d.is_dir():
            warn("no directory for package %r; skipping" % pkg)
            continue

        info("Stowing %s..." % pkg)
        for path in stow_conflicts(pkg):
            backup = path.with_name(path.name + ".bak")
            n = 1
            while backup.exists():
                backup = path.with_name("%s.bak.%d" % (path.name, n))
                n += 1
            print("   backing up %s -> %s" % (path, backup.name))
            if not DRY_RUN:
                path.rename(backup)
        run(["stow", "-d", str(REPO), "-t", str(Path.home()), pkg], check=False)


def stow_conflicts(pkg):
    """Ask stow what would collide, and return the real paths in $HOME.

    A path only counts as a conflict when it exists and is not already a
    symlink into this repo (re-stowing an installed package is not a
    conflict).
    """
    r = subprocess.run(
        ["stow", "-n", "-v", "-d", str(REPO), "-t", str(Path.home()), pkg],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    conflicts = []
    for line in r.stdout.splitlines():
        m = CONFLICT_RE.search(line.strip())
        if not m:
            continue
        target = m.group("target") or m.group("target2")
        path = Path.home() / target.strip()
        if not path.exists() and not path.is_symlink():
            continue
        if path.is_symlink():
            try:
                # Already a link into this repo, so re-stowing is a no-op.
                if REPO in path.resolve().parents:
                    continue
            except OSError:
                pass
        conflicts.append(path)
    return conflicts


# ─── phase 6/7: shell + post ─────────────────────────────────────────────

def set_login_shell():
    """chsh to whichever zsh this OS actually has.

    The path is not portable: /usr/bin/zsh on Arch, /usr/local/bin/zsh on
    FreeBSD, and a Homebrew prefix on macOS.
    """
    zsh = shutil.which("zsh")
    if not zsh:
        warn("zsh not found on PATH; leaving login shell alone")
        return
    if os.environ.get("SHELL", "").endswith("zsh"):
        info("Login shell is already zsh (%s)" % os.environ["SHELL"])
        return
    info("Setting login shell to %s..." % zsh)
    run(["chsh", "-s", zsh], check=False)


def post_install(manager, want_desktop):
    if shutil.which("ya"):
        info("Restoring yazi plugins from package.toml...")
        run(["ya", "pkg", "install"], check=False)

    if want_desktop and manager == "arch" and shutil.which("VencordInstaller"):
        info("Running VencordInstaller...")
        run(["sudo", "VencordInstaller"], check=False)


# ─── main ────────────────────────────────────────────────────────────────

def main():
    global DRY_RUN

    ap = argparse.ArgumentParser(
        description="Install this dotfiles repo on Arch, FreeBSD, macOS, "
                    "Debian, Fedora or Gentoo.")
    ap.add_argument("--desktop", action="store_true",
                    help="also install the Hyprland desktop packages (Arch only)")
    ap.add_argument("--dry-run", action="store_true",
                    help="print every command instead of running it")
    ap.add_argument("--skip-packages", action="store_true",
                    help="do not install any packages")
    ap.add_argument("--skip-stow", action="store_true",
                    help="do not create any symlinks")
    ap.add_argument("--only", nargs="+", metavar="PKG",
                    help="stow only these packages")
    ap.add_argument("--dump-list", metavar="MANAGER", nargs="?", const="arch",
                    help="print the resolved package names for a manager "
                         "(used to regenerate minimal_packages.txt) and exit")
    ap.add_argument("--manager", metavar="KEY",
                    help="force a package manager (arch, freebsd, macos, "
                         "debian, fedora, gentoo) instead of detecting one")
    args = ap.parse_args()

    DRY_RUN = args.dry_run

    manifest = load_manifest()

    if args.dump_list:
        mgr = args.dump_list
        if mgr not in manifest["managers"]:
            die("unknown manager %r" % mgr)
        for group in ("core", "desktop"):
            names = sorted(
                r.name for r in
                resolve(manifest, mgr, want_desktop=True)[0]
                if next(p for p in manifest["packages"] if p["id"] == r.id)
                    .get("group", "core") == group
            )
            print("# --- %s ---" % group)
            print("\n".join(names))
        return

    manager = detect_manager(manifest, args.manager)

    info("Repository:      %s" % REPO)
    info("Package manager: %s" % manager)
    if DRY_RUN:
        info("Dry run -- nothing will be changed.")

    want_desktop = args.desktop
    if want_desktop and manager != "arch":
        die("--desktop is Arch/Hyprland only; %s targets get the core group.\n"
            "   Re-run without --desktop." % manager)
    info("Groups:          %s" % ("core + desktop" if want_desktop else "core"))

    if not args.skip_packages:
        resolved, skipped, unmapped = resolve(manifest, manager, want_desktop)

        if unmapped:
            warn("no %s package name defined for: %s"
                 % (manager, ", ".join(unmapped)))
        for pid, why in skipped:
            print("   skipping %-22s (%s)" % (pid, why))

        unverified = [r for r in resolved if r.unverified]
        if unverified:
            warn("%d name(s) unverified on %s -- validating against the live "
                 "package manager now:" % (len(unverified), manager))
            print("   " + ", ".join(sorted(r.name for r in unverified)))

        bad = validate(manifest, manager, resolved)
        if bad:
            die("%d package name(s) not found by %s:\n%s\n\n"
                "   Fix the names in %s (each entry's 'overrides' for %r), "
                "then re-run.\n   Nothing was installed."
                % (len(bad),
                   manager,
                   "\n".join("     %-24s (manifest id: %s)%s"
                             % (r.name, r.id, "  [was marked unverified]" if r.unverified else "")
                             for r in bad),
                   MANIFEST.relative_to(REPO),
                   manager))

        install_packages(manifest, manager, resolved)

    init_submodules()

    if not args.skip_stow:
        stow_packages(args.only)

    # After stow, so PlugInstall reads the ~/.vimrc the stow step just linked.
    install_vim_plug()

    set_login_shell()
    post_install(manager, want_desktop)

    info("Done.")
    if not DRY_RUN:
        print("\n   Start a new shell (or log out and back in) to pick up zsh.")


if __name__ == "__main__":
    main()
