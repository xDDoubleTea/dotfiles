# dotfiles

![Hyprland](https://img.shields.io/badge/Hyprland-%2358E1FF.svg?style=for-the-badge&logo=hyprland&logoColor=black)

Dotfiles for Arch Linux (Hyprland desktop), and for the CLI subset on FreeBSD,
Debian/Ubuntu, Fedora, Gentoo and macOS.

## Requirements

- **Arch Linux** for the full Hyprland desktop. A minimal install with a non-root
  user that has sudo is preferred.
- **Anything else** (FreeBSD, Debian/Ubuntu, Fedora, Gentoo, macOS) gets the
  *core* CLI tools only. This is what the headless VMs use.

The only hard requirements are `git`, `stow` and a POSIX `/bin/sh`. The bootstrap
installs Python 3 itself if it is missing.

## Installation

```bash
git clone --recurse-submodules https://github.com/xDDoubleTea/dotfiles ~/dotfiles
cd ~/dotfiles
./setup.sh              # core CLI tools, all platforms
./setup.sh --desktop    # core + the Hyprland desktop (Arch only)
```

`--recurse-submodules` is **not optional** — oh-my-zsh, ohmytmux, powerlevel10k
and zsh-vi-mode are all submodules, and without them you get a broken shell. If
you forget it (easy to do), fix an existing clone with:

```bash
git submodule update --init --recursive
```

### What setup.sh does

`setup.sh` is a small POSIX `sh` script that detects the OS, makes sure Python 3
is installed, and hands over to `tools/install.py`, which does the real work:
validate package names, install them, init submodules, stow, and set the login
shell to zsh.

Useful flags:

| Flag | Effect |
| --- | --- |
| `--desktop` | also install the Hyprland desktop group (refused on non-Arch) |
| `--dry-run` | print every command instead of running it |
| `--skip-packages` | stow only, install nothing |
| `--skip-stow` | install packages, create no symlinks |
| `--only PKG...` | stow just these packages |
| `--manager KEY` | force a package manager instead of detecting one |
| `--dump-list [KEY]` | print the resolved package names for a manager |

Start with `./setup.sh --dry-run` on a new machine — it prints the exact package
list and stow operations without touching anything.

### Package manager per OS

Packages are declared once in `packages/manifest.json` and mapped to per-OS
names from there; `minimal_packages.txt` is a generated Arch-only view of it.

| OS | Manager | Groups available |
| --- | --- | --- |
| Arch | `yay` (falls back to `pacman` when no AUR package is in scope) | core + desktop |
| FreeBSD | `pkg` | core |
| macOS | `brew` | core |
| Debian / Ubuntu | `apt-get` | core |
| Fedora | `dnf` | core |
| Gentoo | `emerge` | core |

Names are **not** 1:1 across managers — e.g. `fd` is `fd-find` on FreeBSD/Debian/Fedora,
and `github-cli` on Arch is `gh` everywhere else. Only the Arch names are fully
verified; entries elsewhere are marked `unverified` in the manifest. The installer
checks every name against the local package manager *before* installing anything
and reports all bad names at once, so an unverified name fails loudly rather than
silently doing the wrong thing. When you confirm a name on a real box, drop that
manager from the entry's `unverified` list.

Packages that simply do not exist somewhere (Homebrew has no `zathura`, apt has
no `lazygit`) are declared `null` for that manager and skipped with a message.

## Installing without setup.sh

`setup.sh` is a convenience wrapper, not a requirement. Stowing by hand is fully
supported and is the normal path on a CLI-only VM:

```bash
cd ~/dotfiles
stow nvim        # symlinks ~/.config/nvim -> ~/dotfiles/nvim/.config/nvim
stow zsh         # symlinks ~/.zshrc, ~/.zprofile, ~/.zsh_custom, ...
```

Each top-level directory is a stow package whose contents mirror the path
relative to `$HOME`, so `nvim/.config/nvim` lands at `~/.config/nvim`. See
`all_stowed_files.txt` for the packages `setup.sh` installs by default; other
directories in the repo exist but are stowed manually.

Back up any existing config first (`mv ~/.config/nvim ~/.config/nvim_bak`) — or
let `setup.sh` do it, which renames real conflicting files to `<name>.bak` before
stowing. Remove a package's symlinks with `stow -D <package>`, and re-run
`stow -R <package>` after adding or deleting files inside one.

After stowing, edit the files **in `~/dotfiles`**, not in `~/.config` — the
latter are symlinks pointing back here.

## Shell setup

Everything zsh needs is tracked in this repo; there is nothing left to copy by
hand.

```
zsh/.zshrc                              sets ZSH_CUSTOM="$HOME/.zsh_custom"
zsh/.zsh_custom/alias.zsh               aliases (tracked)
zsh/.zsh_custom/themes/powerlevel10k/   submodule
zsh/.zsh_custom/plugins/zsh-vi-mode/    submodule
zsh/.p10k.zsh                           powerlevel10k config (tracked)
```

Customisations deliberately live **outside** `~/.oh-my-zsh/custom`. oh-my-zsh's
own `.gitignore` starts with `custom/`, so anything kept there is invisible to
both the submodule and this repo, and is lost on a fresh clone — which is exactly
what used to happen to `alias.zsh`, powerlevel10k and zsh-vi-mode. Pointing
`ZSH_CUSTOM` at a stowed directory fixes that, and `git clone --recurse-submodules`
is now enough for a working prompt.

## SSH agent

`zsh/.zprofile` handles this per-OS and needs no configuration:

- **Linux** — uses the systemd user socket, `SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket`.
  Enable it once with `systemctl --user enable --now ssh-agent.socket`.
- **FreeBSD / macOS** — no socket is preset, so it falls back to
  `keychain --eval id_ed25519`, which reuses one agent across logins. `keychain`
  is in the core package group for this reason.

## Editors

Neovim is the main editor (`nvim/`), with NvChad and LazyVim variants in
`nvim_nvchad/` and `nvim_lazy/`.

FreeBSD base ships **neither vim nor nvim**, so the `vim` package installs one.
On the FreeBSD boxes the working config is `vim/.vimrc` — nvim is installed but
not configured there, so use `vim`, or stow `nvim` yourself if you want it.

## Yazi plugins

Plugins under `yazi/.config/yazi/plugins/` are tracked as plain files, so a
normal clone gets them. They are pinned by revision and hash in
`yazi/.config/yazi/package.toml`; `setup.sh` runs `ya pkg install` at the end to
sync them, and you can re-run that at any time.

## Notes

The four submodules are oh-my-zsh, ohmytmux, powerlevel10k and zsh-vi-mode. The neofetch and zathura themes used to be submodules but are now tracked as plain files, so they need nothing extra.

The install script assumes you want the default settings of kitty and hypr to be replaced.

As a user coming from an era where hyprland (uwsm-managed) wasn't a thing, this setup might not work if you chose to start up hyprland with it.

I use Zen-browser as my main browser, it is a fork of firefox with some privacy features and performance improvements.

## Screenshots

## Workspaces and Windows rules

You can switch between workspaces using `super+{number}`, the first `6` workspaces are named, with their name being:
`Zen-browser, Coding, Discord, Media, Games, VScode`.
Discord will be automatically opened once you switched to the workspace `Discord`, and VScode will also be opened once you switched to the workspace `VScode`.

> I use VScode mainly for git stuff (mainly using AI to generate commit messages) and viewing sql databases. I code on neovim. This is why the Coding workspace and the VScode workspace are seperated.

These are done through the workspace rules, you can check `~/dotfiles/hypr/.config/hypr/conf/workspacerules.conf` and [Workspace Rules – Hyprland Wiki](https://wiki.hypr.land/Configuring/Workspace-Rules/).

## Todos

- [ ] Add dock
- [ ] Add some widgets using eww
- [ ] Support for changing light/dark modes.

## Assets

## Tips

You can group some windows together by creating a group using `super+t`
It will look something like this

![Group demo](./assets/screenshots/2025-06-27-155351_hyprshot.png)
Notice that there is a group tab above the window, you can use `super+shift+tab` to cycle forward, and `super+shift+alt+tab` to cycle backward (`super+tab` will not work for some reason)
There are more keyboard shortcuts for group, check it out in the group action section in keybindings settings.

## Credits

- hyprland and waybar configurations were built on top of that of this repo: [typecraft-dev/dotfiles](https://github.com/typecraft-dev/dotfiles)

- Neovim configurations
  - For the main config I use the following:
    [ntk148v/neovim-config: A minimal neovim configuration written in Lua](https://github.com/ntk148v/neovim-config/tree/master?tab=readme-ov-file)
  - [NvChad](https://nvchad.com/)
  - [🚀 Getting Started | LazyVim](https://www.lazyvim.org/)
  - [LunarVim/Launch.nvim: 🚀 Launch.nvim is modular starter for Neovim.](https://github.com/LunarVim/Launch.nvim)

- Hyprland
  [hyprland.org/](https://hypr.land/)
