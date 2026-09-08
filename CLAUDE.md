# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal Arch Linux dotfiles for a Hyprland (Wayland) desktop, deployed with GNU `stow`. There is no build system, no test suite, and no application code — every top-level directory is a *stow package*, and "running" a change means restarting the program whose config was edited.

## Repository layout convention

Each top-level directory mirrors the path structure relative to `$HOME`:

- `nvim/.config/nvim/...` → symlinked to `~/.config/nvim/...`
- `zsh/.zshrc` → symlinked to `~/.zshrc`
- `tmux/.tmux/...` → symlinked to `~/.tmux/...`

So when adding a file, place it at `<package>/<path-relative-to-home>`. Do **not** create a package directory that doesn't reproduce the home-relative path.

`all_stowed_files.txt` is the authoritative list of packages `setup.sh` stows — a directory not listed there is never deployed by the installer (e.g. `nvim_lazy`, `alacritty`, `ghostty`, `yazi`, `bat` exist but are stowed manually). If you add a package that should be installed by default, add its name to that file.

`.stow-local-ignore` excludes `sddm_theme`, VCS metadata, and top-level `README*`/`LICENSE*` from stowing. `sddm_theme/breeze` is installed manually to `/usr/share/sddm/themes`.

## Common commands

```bash
./setup.sh                          # core CLI tools + submodules + stow, any supported OS
./setup.sh --desktop                # core + Hyprland desktop (Arch only; refused elsewhere)
./setup.sh --dry-run                # print every command, change nothing
./setup.sh --manager freebsd --dry-run   # exercise another OS's path from here
python3 tools/install.py --dump-list arch  # regenerate minimal_packages.txt
stow <package>                      # deploy one package (run from repo root)
stow -D <package>                   # remove its symlinks
stow -R <package>                   # restow after adding/removing files in a package
git submodule update --init --recursive   # recover a clone made without --recurse-submodules
```

`setup.sh` is strict POSIX sh (it must run under FreeBSD's ash) and does nothing
but locate Python 3 and exec `tools/install.py`. Check it with
`zsh --emulate sh -n setup.sh` — plain `sh -n` proves little here because
`/bin/sh` is bash on Arch. `tools/install.py` is stdlib-only by design; do not
add third-party dependencies to it.

Packages are declared in `packages/manifest.json`, keyed by manager
(`arch`/`freebsd`/`macos`/`debian`/`fedora`/`gentoo`), split into `core` (every
OS) and `desktop` (Arch-only, opt-in). Names are not 1:1 across managers. Only
the Arch column is verified; other entries carry an `unverified` list, and the
installer validates every name against the local package manager before
installing anything. `minimal_packages.txt` is **generated** from the manifest —
edit the manifest, not that file.

Because the deployed configs are symlinks back into this repo, edit files **here**, not in `~/.config`.

## Submodules

`tmux/.tmux` (gpakosz/.tmux), `zsh/.oh-my-zsh` (ohmyzsh), `zsh/.zsh_custom/themes/powerlevel10k` and `zsh/.zsh_custom/plugins/zsh-vi-mode` (a fork: xDDoubleTea/zsh-vi-mode) are git submodules — upstream code, don't edit in place. The user-owned overrides are `tmux/.tmux.conf.local` and `zsh/.zshrc`. `zathura/.config/zathura` and `neofetch` themes are also vendored upstream copies.

## Hyprland config

`hypr/.config/hypr/hyprland.conf` is the live entry point; it `source`s, in order: `mocha.conf` (Catppuccin Mocha color variables like `$mauve`, `$base`, plus `$fooAlpha` hex forms used inside `rgba()`), then `conf/startups.conf`, `conf/monitor.conf`, `conf/windowrules.conf`, `conf/workspacerules.conf`, `conf/cursor.conf`, `conf/keybindings.conf`.

The parallel `*.lua` files (`hyprland.lua`, `mocha.lua`, `conf/keybindings.lua`, `conf/windowrules.lua`, `conf/autostart.lua`, `conf/programs.lua`) are an in-progress port to Hyprland's Lua config format. They are **not** loaded by `hyprland.conf`; changes to keybindings/rules must go in the `.conf` files to take effect, and ideally be mirrored into the `.lua` ones.

Colors: prefer the existing `$catppuccin-name` variables over literal hex. The same palette is duplicated per-app (`waybar/.config/waybar/mocha.css`, kitty's `Catppuccin-Mocha.conf`, `FZF_DEFAULT_OPTS` in `.zshrc`) — a theme change usually means touching several packages.

Reload after editing: `hyprctl reload` (Hyprland), `pkill -SIGUSR1 waybar` or restart waybar, `kitty-reload` shell function for kitty.

## Neovim

Three separate configs, only two stowed:

- `nvim/` — the primary config (lazy.nvim, 4-space Lua). `init.lua` bootstraps lazy.nvim and requires `options`, `mappings`, `autocmds`, `plugins` in that order (options/mappings must precede plugins for the leader key), then optionally `custom`. Plugin specs live in `lua/plugins/init.lua` with per-plugin setup in `lua/plugins/configs/`; user-added plugins go in `lua/custom/plugins/<name>.lua`.
- `nvim_nvchad/` — an NvChad-based alternative, stowed to `~/.config/nvim_nvchad` (use with `NVIM_APPNAME=nvim_nvchad nvim`).
- `nvim_lazy/` — LazyVim variant, not in `all_stowed_files.txt`.

Formatting for `nvim/`: StyLua per `nvim/.config/nvim/.stylua.toml` (120 cols, 4-space indent, double quotes, sorted requires); `.pre-commit-config.yaml` there runs StyLua plus prettier on markdown/yaml. `.luacheckrc` declares the allowed globals.

`nvim/init.lua` hard-requires `git`, `rg`, and `fd`/`fdfind` on `$PATH` and quits otherwise.

## Zsh

`.zshrc` sets `ZSH_CUSTOM="$HOME/.zsh_custom"` before sourcing oh-my-zsh, so
customizations live in the tracked `zsh/.zsh_custom/` (stowed to `~/.zsh_custom`)
rather than `~/.oh-my-zsh/custom/`. This is deliberate and load-bearing:
oh-my-zsh's own `.gitignore` begins with `custom/`, so anything placed there is
invisible to both the submodule and this repo and is lost on a fresh clone.
Never move `alias.zsh`, the p10k theme, or plugins back under `.oh-my-zsh/custom/`.

`.zshrc` unconditionally calls `zoxide`, `direnv`, `navi` and `atuin`; all four
are in the manifest's `core` group. `zsh/.zprofile` handles the SSH agent per-OS
(systemd socket on Linux, `keychain` fallback on FreeBSD/macOS) and is already
correct — leave it alone.

## Scripts

Helper scripts are colocated with the config that calls them and are referenced by their **deployed** path (`~/.config/...`), not a repo path: `hypr/.config/hypr/scripts/`, `waybar/.config/waybar/scripts/` (zsh + python, wired into `config.jsonc` custom modules), `eww/.config/eww/scripts/`, `yt-dlp/.config/yt-dlp/download_scripts.py`. Keep the executable bit when adding one.

## Machine-specific values

`hyprland.conf` and `conf/monitor.conf` hardcode this machine's setup (`$mainMonitor = DP-1` at 2560x1440, `AQ_DRM_DEVICES=/dev/dri/card1:/dev/dri/card0`, `QT_QPA_PLATFORMTHEME=qt6ct`). Files that would leak per-machine state are gitignored (`kitty/.config/kitty/ssh.conf`, `kitty/.config/kitty/mappings.conf`, `btop.conf`, `waypaper/config.ini`, `naviterm/`, `waybar/.config/waybar/scripts/last_screen_temp.txt`) — don't `git add -f` them.

`*_backup.*` / `*_bak.*` / `backup_*` files (waybar, swaync, hypr, neofetch, kitty) are the user's kept-around previous versions, not dead code to clean up.

## Docs

`README.md` documents the install flow, stow semantics, workspace/keybinding behaviour, and credits for upstream configs. Update it when changing `setup.sh`, the package list, or user-visible keybindings.
