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

Super key is the windows key.  
Basic key binding list used in this configuration:

- Open terminal (kitty) `super+q`
- Close a window `super+c`
- Exit hyprland `super+m`
- Toggle window to floating mode `super+b`
- Show clipboard history `super+v` (NOT toggle, it will spawn infinitely if you keep pressing it.)
- Lock the screen `super+shift+l`
- Reload configuration `super+shift+r`
- Screenshot selected region `super+shift+s`
- Screenshot the focused window `PrintScreen`
- Screenshot the focused monitor `super+PrintScreen`
- Full screen a window `super+f`
- File explorer `super+e`
- Reload waybar `super+alt+shift+g`
- Toggle notification center `super+shift+n`

Configuring keybinds is done by modifing `~/dotfiles/hypr/.config/hypr/conf/keybindings.conf`.

To bind a key to an action, the basic syntax is

```
bind = MODKEY, key, exec, command
```

For instance, if you want to bind `windows+x` to open zen-browser, you do:

```
bind = super, X, exec, zen-browser
```

If you have a keyboard that has music control keys or volume control keys, they are bind to :

```
binde = , XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
binde = , XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%
binde = , XF86AudioMut, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle

# Media keys through playerctl
bindl = , XF86AudioPlay, exec, playerctl play-pause
bindl = , XF86AudioPrev, exec, playerctl previous
bindl = , XF86AudioNext, exec, playerctl next
```

Complete list for these kind of keys: [libxkbcommon/include/xkbcommon/xkbcommon-keysyms.h at master · xkbcommon/libxkbcommon](https://github.com/xkbcommon/libxkbcommon/blob/master/include/xkbcommon/xkbcommon-keysyms.h)

Here `bind[flag]` is a hyprland command to bind a key to an action. `e` is for repeat, and `l` is for lock, meaning the play-pause, previous and next buttons will lock until you release them. See more flags at [Binds#bind-flags – Hyprland Wiki](https://wiki.hypr.land/Configuring/Binds/#bind-flags).

## Workspaces and Windows rules

You can switch between workspaces using `super+{number}`, the first `6` workspaces are named, with their name being:  
`Zen-browser, Coding, Discord, Media, Games, VScode`.  
Discord will be automatically opened once you switched to the workspace `Discord`, and VScode will also be opened once you switched to the workspace `VScode`.  

> I use VScode mainly for git stuff (mainly using AI to generate commit messages) and viewing sql databases. I code on neovim. This is why the Coding workspace and the VScode workspace are seperated.

These are done through the workspace rules, you can check `~/dotfiles/hypr/.config/hypr/conf/workspacerules.conf` and [Workspace Rules – Hyprland Wiki](https://wiki.hypr.land/Configuring/Workspace-Rules/).

## Todos

- [] Add dock
- [] Add some widgets using eww

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
