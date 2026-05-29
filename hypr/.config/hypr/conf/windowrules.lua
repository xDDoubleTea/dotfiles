--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local suppressMaximizeRule = hl.window_rule({
	-- Ignore maximize requests from all apps. You'll probably like this.
	name = "suppress-maximize-events",
	match = { class = ".*" },

	suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "change-wallpaper",
	match = { class = "^([Ww]aypaper)$" },
	float = true,
	size = { 1280, 720 },
	center = true,
})

hl.window_rule({
	name = "vscode",
	match = { class = "^([Cc]ode)(.*)" },
	opacity = 0.9,
	no_blur = true,
})

hl.window_rule({
	name = "clipboard-manager",
	match = { class = "^(com.github.hluk.copyq)" },
	float = true,
	opacity = 0.8,
	size = { 1024, 700 },
	center = true,
})

hl.window_rule({
	name = "pavucontrol panel",
	match = { class = "^(org.pulseaudio.pavucontrol)$|^(nm-connection-editor)$" },
	float = true,
	center = true,
	size = { 1280, 720 },
})
