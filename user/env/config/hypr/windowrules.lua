--#############################
--## WINDOWS AND WORKSPACES ###
--#############################

-- Wildcard for randomly plugged in monitors like projectors

hl.monitor {
  output = '',
  mode = 'preferred',
  position = 'auto',
  scale = '1',
}

-- See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
--
-- Declare basic setups for workspaces
-- Monitor 1
hl.workspace_rule {
  workspace = '4',
  default_name = 'Terminal',
  monitor = MONITOR1,
  on_created_empty = PREFIX .. ' ' .. TERMINAL,
}

hl.workspace_rule {
  workspace = '1',
  default_name = 'Browser',
  monitor = MONITOR1,
  layout = 'scrolling',
}

hl.workspace_rule {
  workspace = '7',
  default_name = 'Gaming',
  monitor = MONITOR1,
  layout = 'scrolling',
}

hl.workspace_rule {
  workspace = '6',
  monitor = MONITOR1,
}

hl.workspace_rule {
  workspace = '8',
  monitor = MONITOR1,
}

hl.workspace_rule {
  workspace = '9',
  monitor = MONITOR1,
}

hl.workspace_rule {
  workspace = '10',
  monitor = MONITOR1,
}

-- monitor 2
hl.workspace_rule {
  workspace = '2',
  monitor = MONITOR2,
}

hl.workspace_rule {
  workspace = '3',
  default_name = 'Secret',
  monitor = MONITOR2,
  on_created_empty = PREFIX .. ' keepassxc',
}

hl.workspace_rule {
  workspace = '5',
  default_name = 'Comms',
  monitor = MONITOR2,
}

--##################
--## WINDOWRULES ###
--##################
-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
hl.window_rule {
  match = {
    class = '.*',
  },
  suppress_event = 'maximize',
}

--# mpv ##
hl.window_rule {
  match = {
    class = 'mpv',
  },
  fullscreen = true,
}

--# Browser ##
hl.window_rule {
  match = {
    tag = 'Browser',
  },
  workspace = '1',
}

hl.window_rule {
  match = {
    class = 'firefox-esr',
  },
  tag = '+Browser',
}

hl.window_rule {
  match = {
    class = 'Brave-browser',
  },
  tag = '+Browser',
}

hl.window_rule {
  match = {
    class = 'zen',
  },
  tag = '+Browser',
}

hl.window_rule {
  match = {
    class = 'floorp',
  },
  tag = '+Browser',
}

--# Secrets ##
-- windowrule = workspace 3, match:tag Secret
-- windowrule = tag +Secret, match:class org.keepassxc.KeePassXC
-- windowrule = tag -Secret, initialTitle: Auto-Type - KeePassXc
hl.window_rule {
  match = {
    initial_title = 'Auto-Type*',
  },
  float = true,
}

--# Comms ##
hl.window_rule {
  match = {
    tag = 'Comms',
  },
  workspace = '5',
}

hl.window_rule {
  match = {
    class = 'vesktop',
  },
  tag = '+Comms',
}

hl.window_rule {
  match = {
    class = 'signal',
  },
  tag = '+Comms',
}

hl.window_rule {
  match = {
    class = 'Element',
  },
  tag = '+Comms',
}

--# EMAIL ##
hl.window_rule {
  match = {
    tag = 'Email',
  },
  workspace = '6',
}

hl.window_rule {
  match = {
    class = 'thunderbird',
  },
  tag = '+Email',
}

--# Gaming ##
hl.window_rule {
  match = {
    tag = 'Gaming',
  },
  workspace = '7',
}

--All steam windows are gaming
hl.window_rule {
  match = {
    class = 'steam',
  },
  tag = '+Gaming',
}

hl.window_rule {
  match = {
    class = 'steam\\_app\\_[0-9]{6}|steam\\_app\\_[0-9]{7}',
  },
  tag = '+Gaming',
}

hl.window_rule {
  match = {
    class = 'gamescope',
  },
  tag = '+Gaming',
  fullscreen = true,
}

hl.window_rule {
  match = {
    class = 'steam\\_app\\_[0-9]{6}|steam\\_app\\_[0-9]{7}',
  },
  idle_inhibit = 'focus',
}

hl.window_rule {
  match = {
    class = 'gamescope',
  },
  idle_inhibit = 'focus',
}

--# PDF Viewer ##
-- For some reason the default is to have this window floating
hl.window_rule {
  match = {
    class = 'sioyek',
  },
  float = false,
}

--# Special Workspaces ##
-- Scratchpads
hl.window_rule {
  match = {
    class = '(com.saivert.pwvucontrol)',
  },
  tag = '+Scratchpads',
}

hl.window_rule {
  match = {
    class = '(music-player)',
  },
  tag = '+Scratchpads',
}

hl.window_rule {
  match = {
    class = '(blueberry.py)',
  },
  tag = '+Scratchpads',
}

hl.window_rule {
  match = {
    class = '(scratchpad_terminal)',
  },
  tag = '+Scratchpads',
}

hl.window_rule {
  match = {
    class = '(vim_anywhere)',
  },
  tag = '+Scratchpads',
}

hl.window_rule {
  match = {
    class = '^($networkmanager)$',
  },
  tag = '+Scratchpads',
}

hl.window_rule {
  match = {
    class = '^(scratchpad_quick_capture)$',
  },
  tag = '+Scratchpads',
}

hl.window_rule {
  match = {
    tag = 'Scratchpads',
  },
  float = true,
  size = '(monitor_w*.8) (monitor_h*.5)',
  center = true,
  opacity = 0.80,
}

--# TERMINAL ##
hl.window_rule {
  match = {
    class = '(scratchpad_terminal)',
  },
  workspace = 'special:scratchpad_terminal',
}

--# QUICK CAPTURE ##
hl.window_rule {
  match = {
    class = '^(scratchpad_quick_capture)$',
  },
  workspace = 'special:scratchpad_quick_capture',
}
