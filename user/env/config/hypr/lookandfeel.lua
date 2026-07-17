--####################
--## LOOK AND FEEL ###
--####################

-- Refer to https://wiki.hyprland.org/Configuring/Variables/

-- https://wiki.hyprland.org/Configuring/Variables/#general

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.animation({
	leaf = "global",
	enabled = true,
	speed = 10,
	bezier = "default",
})
hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 2,
	bezier = "myBezier",
})
hl.animation({
	leaf = "windowsOut",
	enabled = true,
	speed = 2,
	bezier = "default",
	style = "popin 80%",
})
hl.animation({
	leaf = "border",
	enabled = true,
	speed = 7,
	bezier = "default",
})
hl.animation({
	leaf = "borderangle",
	enabled = true,
	speed = 8,
	bezier = "default",
})
hl.animation({
	leaf = "fade",
	enabled = true,
	speed = 2,
	bezier = "default",
})
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 2,
	bezier = "default",
})
hl.animation({
	leaf = "specialWorkspace",
	enabled = true,
	speed = 3,
	bezier = "default",
	style = "slidefadevert -50%",
})

hl.workspace_rule({
	workspace = "w[tv1]s[false]",
	gaps_out = 0,
	gaps_in = 0,
})

hl.workspace_rule({
	workspace = "f[1]s[false]",
	gaps_out = 0,
	gaps_in = 0,
})

hl.window_rule({
	match = {
		float = 0,
		workspace = "w[tv1]s[false]",
	},
	border_size = 0,
	rounding = 0,
})

hl.window_rule({
	match = {
		float = 0,
		workspace = "f[1]s[false]",
	},
	border_size = 0,
	rounding = 0,
})
-- hl.env("GDK_SCALE", "2")
hl.config({
	general = {
		gaps_in = 1,
		gaps_out = 5,
		border_size = 2,
		-- Set to true enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = false,
		-- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
		allow_tearing = false,
		layout = "dwindle",
	},
	-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/XWayland/
	--xwayland = {
	--force_zero_scaling = true,
	--},
	-- https://wiki.hyprland.org/Configuring/Variables/#decoration
	decoration = {
		-- rounding = 10
		-- Change transparency of focused and unfocused windows
		-- active_opacity = 0.85
		-- inactive_opacity = 0.85
		shadow = {
			-- This is managed in the nix part of the config because it changes depending on the energy settings
			-- enabled = true
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
		-- https://wiki.hyprland.org/Configuring/Variables/#blur
		blur = {
			-- This is managed in the nix part of the config because it changes depending on the energy settings
			-- enabled = true
			size = 3,
			passes = 3,
			vibrancy = 0.1696,
		},
	},
	-- https://wiki.hyprland.org/Configuring/Variables/#animations
	animations = {
		enabled = true,
		-- Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
	},
	-- See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
	dwindle = {
		preserve_split = true, -- You probably want this
	},
	-- See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
	master = {
		new_status = "master",
	},
	-- Smart gaps/ No gaps if single window
	-- https://wiki.hypr.land/Configuring/Workspace-Rules/#smart-gaps
	-- https://wiki.hyprland.org/Configuring/Variables/#misc
	misc = {
		force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
		-- This is managed in the nix part of the config because it changes depending on the energy settings
		-- disable_autoreload = true
		-- vfr = true
	},
})
