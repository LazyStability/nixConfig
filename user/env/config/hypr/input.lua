--############
--## INPUT ###
--############

-- https://wiki.hyprland.org/Configuring/Variables/#input

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

hl.device({
	name = "ydotoold-virtual-device",
	kb_layout = "us",
	kb_options = "",
	kb_variant = "",
})

hl.config({
	input = {
		kb_layout = "de, us",
		repeat_delay = 300,
		repeat_rate = 50,
		follow_mouse = 1,
		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
		touchpad = {
			natural_scroll = false,
		},
	},
	-- Input for drawing tablets
	-- For more details:
	-- https://wiki.hypr.land/Configuring/Variables/#tablet
	-- New Nvdia problem ref: https://github.com/hyprwm/Hyprland/issues/8036
	cursor = {
		no_hardware_cursors = true,
	},
	-- Example per-device config
	-- See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
})
