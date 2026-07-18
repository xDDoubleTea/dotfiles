require("conf.programs")
---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local supershift = "SUPER + SHIFT"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(Terminal))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(FileManager))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(ClipboardManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(Menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(WallpaperChanger))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(Notification))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + B", hl.dsp.window.float())

hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region -o $HOME/Pictures/hyprshot/"))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("hyprshot -m output -o $HOME/Pictures/hyprshot/"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m window -o $HOME/Pictures/hyprshot/"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Swap with mainMod + shift
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.swap({ direction = "down" }))
-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys for volume
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)

-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Group

hl.bind(mainMod .. " + T", hl.dsp.group.toggle({ hl.get_active_window() }))
hl.bind(supershift .. " + TAB", hl.dsp.group.next())
hl.bind(supershift .. " + ALT + TAB", hl.dsp.group.prev())
hl.bind(supershift .. " + CTRL + L", hl.dsp.group.lock_active())
hl.bind(supershift .. " + CTRL + left", hl.dsp.window.move({ direction = "left", group_aware = true }))
hl.bind(supershift .. " + CTRL + right", hl.dsp.window.move({ direction = "right", group_aware = true }))
hl.bind(supershift .. " + CTRL + up", hl.dsp.window.move({ direction = "up", group_aware = true }))
hl.bind(supershift .. " + CTRL + down", hl.dsp.window.move({ direction = "down", group_aware = true }))
hl.bind(supershift .. " + CTRL + O", hl.dsp.window.move({ out_of_group = true }))

-- Misc

hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("env LC_ALL= LC_MONETARY=zh_TW.UTF-8 rofi -show calc -modi calc"))
hl.bind(mainMod .. " + semicolon", hl.dsp.exec_cmd("rofimoji"))

-- Reload waybar
hl.bind(mainMod .. " + ALT + SHIFT + G", hl.dsp.exec_cmd("killall waybar && waybar"))
