# dotfiles

Dotfiles for arch linux (STILL TESTING)

## Requirements

Arch linux (minimal setup is prefered)

## Installation

```bash
 sudo pacman -S git
 git clone --recurse-submodules https://github.com/xDDoubleTea/dotfiles ~/dotfiles
 cd dotfiles/
 chmod +x ./setup.sh
 ./setup.sh
```

Reboot if necessary.

Take a look at the minimal_packages.txt to know what packages were installed.

You're all setup! (STILL TESTING)

## Notes

The `--recurse-submodules` option in git clone is necessary, as it clones the submodules in this repo, which are dependencies for ohmyzsh, ohmytmux, neofetch theme and zathura theme to work.

The install script assumes you want the default settings of kitty and hypr to be replaced.

As a user coming from an era where hyprland (uwsm-managed) wasn't a thing, this setup might not work if you chose to start up hyprland with it.

## Screenshots

## KeyBinds

## Assets

## Credits

- hyprland and waybar configurations were built on top of that of this repo: [typecraft-dev/dotfiles](https://github.com/typecraft-dev/dotfiles)

- Neovim configurations  
  - For the main config I use lazyvim:  
    [🚀 Getting Started | LazyVim](https://www.lazyvim.org/)  
  - [NvChad](https://nvchad.com/)

- Hyprland  
[hyprland.org/](https://hypr.land/)
