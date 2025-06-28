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
  - For the main config I use lazyvim:  
    [🚀 Getting Started | LazyVim](https://www.lazyvim.org/)  
  - [NvChad](https://nvchad.com/)

- Hyprland  
[hyprland.org/](https://hypr.land/)
