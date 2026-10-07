---------------------
---- KEYBINDINGSS ---
---------------------

-- See https://wiki.hyprland.org/Configuring/Keywords/

-- Search bindings
hl.bind(
  MAINMOD .. ' + y',
  hl.dsp.exec_cmd(HYPR_BINDS),
  { description = 'Search bindings' }
)

-- technicely a bind, but not really
hl.bind(
  'switch:Lid Switch',
  hl.dsp.exec_cmd(HYPR_LID_SWITCH),
  { locked = true, description = 'Handle lid switch' }
)

-- Volume control
hl.bind(
  'XF86AudioRaiseVolume',
  hl.dsp.exec_cmd 'wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+',
  { repeating = true, description = 'Raise Volume' }
)
hl.bind(
  'XF86AudioLowerVolume',
  hl.dsp.exec_cmd 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-',
  { repeating = true, description = 'Lower Volume' }
)
hl.bind(
  'XF86AudioMute',
  hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle',
  { locked = true, description = 'Mute sound' }
)
hl.bind(
  'XF86AudioMicMute',
  hl.dsp.exec_cmd 'wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle',
  { locked = true, description = 'Mute microphone' }
)
hl.bind(
  'xf86Sleep',
  hl.dsp.exec_cmd 'systemctl suspend',
  { locked = true, description = 'Sleep' }
)
hl.bind(
  'XF86MonBrightnessDown',
  hl.dsp.exec_cmd 'hyprctl hyprsunset gamma -10',
  { locked = true, repeating = true, description = 'Lower brightness' }
)
hl.bind(
  'XF86MonBrightnessUp',
  hl.dsp.exec_cmd 'hyprctl hyprsunset gamma +10',
  { locked = true, repeating = true, description = 'Raise brightness' }
)
hl.bind(
  MAINMOD .. ' + XF86MonBrightnessDown',
  hl.dsp.exec_cmd 'hyprctl hyprsunset temperature -500',
  { locked = true, repeating = true, description = 'Lower color temperature' }
)
hl.bind(
  MAINMOD .. ' + XF86MonBrightnessUp',
  hl.dsp.exec_cmd 'hyprctl hyprsunset temperature +500',
  { locked = true, repeating = true, description = 'Raise color temperature' }
)

hl.bind(
  'XF86AudioPlay',
  hl.dsp.exec_cmd 'playerctl play-pause',
  { locked = true, description = 'Play/Pause music' }
)
hl.bind(
  'XF86AudioNext',
  hl.dsp.exec_cmd 'playerctl next',
  { locked = true, description = 'Skip active song' }
)
hl.bind(
  'XF86AudioPrev',
  hl.dsp.exec_cmd 'playerctl previous',
  { locked = true, description = 'Go to previous song' }
)

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
hl.bind(
  MAINMOD .. ' + RETURN',
  hl.dsp.exec_cmd(TERMINAL),
  { description = 'Open terminal' }
)
hl.bind(
  MAINMOD .. ' + E',
  hl.dsp.exec_cmd(TERMINAL .. FILEMANAGER),
  { description = 'Open filemanager' }
)
hl.bind(
  MAINMOD .. ' + M',
  hl.dsp.exec_cmd(TERMINAL .. ' --class music-player ' .. MUSIC_PLAYER),
  { description = 'Open Music player' }
)
hl.bind(
  MAINMOD .. ' + I',
  hl.dsp.exec_cmd(MENU),
  { description = 'Open App launcher' }
)
hl.bind(
  MAINMOD .. ' + N',
  hl.dsp.exec_cmd 'swaync-client -t -sw',
  { description = 'Open Notificiation Daemon' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + R',
  hl.dsp.exec_cmd 'dbus-send --session --type=method_call --dest=org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow.requestGlobalAutoType',
  { description = 'Open keypass autotype' }
)
-- Screenshot a window
hl.bind(
  MAINMOD .. ' + PRINT',
  hl.dsp.exec_cmd '$HOME/.local/bin/screenshot window',
  { description = 'Screenshot a window' }
)
-- Screenshot a monitor
hl.bind(
  'PRINT',
  hl.dsp.exec_cmd '$HOME/.local/bin/screenshot full',
  { description = 'Screenshot a monitor' }
)
-- Screenshot a region
hl.bind(
  MAINMOD .. ' + SHIFT + PRINT',
  hl.dsp.exec_cmd '$HOME/.local/bin/screenshot select',
  { description = 'Screenshot a region' }
)

--- Native --
hl.bind(
  MAINMOD .. ' + SHIFT + Q',
  hl.dsp.window.close(),
  { description = 'Kill a window' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + N',
  hl.dsp.exec_cmd 'hyprlock',
  { description = 'Lock the session' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + N',
  hl.dsp.exec_cmd 'dbus-send --session --type=method_call --dest=org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow.lockAllDatabases',
  { description = 'Lock all keepass databases' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + V',
  hl.dsp.window.float { action = 'toggle' },
  { description = 'Toggle floating' }
)
hl.bind(
  MAINMOD .. ' + V',
  hl.dsp.exec_cmd '/usr/bin/vim-anywhere',
  { description = 'Vim Anywhere' }
)
hl.bind(
  MAINMOD .. ' + F',
  hl.dsp.window.fullscreen { mode = 'fullscreen', action = 'toggle' },
  { description = 'Fullscreen' }
)

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Uncommon-tips-and-tricks/#cycle-layout-for-current-workspace
hl.bind(MAINMOD .. ' + O', function()
  local layouts = { 'scrolling', 'dwindle', 'master', 'monocle' }
  local workspace = hl.get_active_workspace()
  if hl.get_active_special_workspace() then
    workspace = hl.get_active_special_workspace()
  end

  local next_layout = 'dwindle'

  if not workspace then
    return
  end

  for i = 1, #layouts do
    if layouts[i] == workspace.tiled_layout then
      local next_layout_idx = (i % #layouts) + 1
      next_layout = layouts[next_layout_idx]
      break
    end
  end

  if workspace.special then
    hl.workspace_rule {
      workspace = tostring(workspace.name),
      layout = next_layout,
    }
  else
    hl.workspace_rule { workspace = tostring(workspace.id), layout = next_layout }
  end
end, { description = 'Cycle through layouts for this workspace' })

-- LDUR with per layout bindings
local function layout_bind(bind_table)
  return function()
    local workspace = hl.get_active_special_workspace()
      or hl.get_active_workspace()

    if not workspace then
      return
    end

    local layout = workspace.tiled_layout

    if bind_table[layout] then
      hl.dispatch(bind_table[layout])
    end
  end
end

hl.bind(
  MAINMOD .. ' + h',
  layout_bind {
    dwindle = hl.dsp.focus { direction = 'left' },
    scrolling = hl.dsp.layout 'focus l',
    monocle = hl.dsp.layout 'cycleprev',
    master = hl.dsp.focus { direction = 'left' },
  },
  { description = 'Switch to window left' }
)
hl.bind(
  MAINMOD .. ' + j',
  hl.dsp.focus { direction = 'down' },
  { description = 'Switch to window down' }
)
hl.bind(
  MAINMOD .. ' + k',
  hl.dsp.focus { direction = 'up' },
  { description = 'Switch to window up' }
)
hl.bind(
  MAINMOD .. ' + l',
  layout_bind {
    dwindle = hl.dsp.focus { direction = 'right' },
    scrolling = hl.dsp.layout 'focus r',
    monocle = hl.dsp.layout 'cyclenext',
    master = hl.dsp.focus { direction = 'right' },
  },
  { description = 'Switch to window right' }
)

-- Switch windows
hl.bind(
  MAINMOD .. ' + SHIFT + h',
  layout_bind {
    dwindle = hl.dsp.window.swap { direction = 'left' },
    scrolling = hl.dsp.layout 'swapcol l',
    monocle = hl.dsp.layout 'cycleprev',
    master = hl.dsp.layout 'cycleprev',
  },
  { description = 'Switch to window left' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + j',
  hl.dsp.window.swap { direction = 'd' },
  { description = 'Switch to window down' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + k',
  hl.dsp.window.swap { direction = 'u' },
  { description = 'Switch to window up' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + l',
  layout_bind {
    dwindle = hl.dsp.window.swap { direction = 'right' },
    scrolling = hl.dsp.layout 'swapcol r',
    monocle = hl.dsp.layout 'cyclenext',
    master = hl.dsp.layout 'cyclenext',
  },
  { description = 'Switch to window right' }
)

for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  -- Switch workspaces with mainMod + [0-9]
  hl.bind(
    MAINMOD .. ' + ' .. key,
    hl.dsp.focus { workspace = i },
    { description = 'Switch to workspace ' .. i }
  )
  -- Move active window to a workspace with mainMod + SHIFT + [0-9]
  hl.bind(
    MAINMOD .. ' + SHIFT + ' .. key,
    hl.dsp.window.move(
      { workspace = i },
      { description = 'Move window to workspace ' .. i }
    )
  )
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(
  MAINMOD .. ' + mouse_down',
  hl.dsp.focus { workspace = 'e+1' },
  { description = 'Scroll up workspaces with mouse' }
)
hl.bind(
  MAINMOD .. ' + mouse_up',
  hl.dsp.focus { workspace = 'e-1' },
  { description = 'Scroll down workspaces with mouse' }
)

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(
  MAINMOD .. ' + mouse:272',
  hl.dsp.window.drag(),
  { description = 'Move window with mouse' }
)
hl.bind(
  MAINMOD .. ' + mouse:273',
  hl.dsp.window.resize(),
  { description = 'Resize window with mouse' }
)

---------------
---- submaps --
---------------
hl.bind(
  MAINMOD .. ' + D',
  hl.dsp.submap 'scratch',
  { description = 'Enter scratchpad & script submap' }
)
hl.bind(
  MAINMOD .. ' + R',
  hl.dsp.submap 'resize',
  { description = 'Enter resize submap' }
)
hl.bind(
  MAINMOD .. '+ SHIFT + M',
  hl.dsp.submap 'powermenu',
  { description = 'Enter powermenu submap' }
)

---------------------
--- Monitor submap --
---------------------

hl.define_submap('powermenu', function()
  hl.bind('p', hl.dsp.exec_cmd 'poweroff', { description = 'Power off' })
  hl.bind('r', hl.dsp.exec_cmd 'reboot', { description = 'Reboot' })
  hl.bind(
    'h',
    hl.dsp.exec_cmd 'systemctl hibernate',
    { description = 'Hibernate' }
  )
  hl.bind(
    'm',
    hl.dsp.exec_cmd 'loginctl terminate-user $(whoami)',
    { description = 'logout/close session' }
  )
  hl.bind('N', hl.dsp.exec_cmd 'hyprlock', { description = 'Lock the session' })
  hl.bind(
    'N',
    hl.dsp.exec_cmd 'dbus-send --session --type=method_call --dest=org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow.lockAllDatabases',
    { description = 'Lock all keepass databases' }
  )

  hl.bind(
    'catchall',
    hl.dsp.submap 'reset',
    { repeating = true, description = 'Exit submap' }
  )
end)

--------------------
--- resize submap --
--------------------

hl.define_submap('resize', function()
  -- Set repeatable binds for resizing the active window.
  hl.bind(
    'h',
    hl.dsp.window.resize { x = -30, y = 0, relative = true },
    { repeating = true, description = 'Resize window left' }
  )
  hl.bind(
    'j',
    hl.dsp.window.resize { x = 0, y = 30, relative = true },
    { repeating = true, description = 'Resize window down' }
  )
  hl.bind(
    'k',
    hl.dsp.window.resize { x = 0, y = -30, relative = true },
    { repeating = true, description = 'Resize window up' }
  )
  hl.bind(
    'l',
    hl.dsp.window.resize { x = 30, y = 0, relative = true },
    { repeating = true, description = 'Resize window right' }
  )

  -- Use `reset` to go back to the global submap
  hl.bind('escape', hl.dsp.submap 'reset', { description = 'Exit submap' })

  -- Reset the submap, which will return to the global submap
end)

-------------------------
--- Scratchpads Submap --
-------------------------
hl.define_submap('scratch', 'reset', function()
  --------------
  --- Scripts --
  --------------
  hl.bind(
    MAINMOD .. ' + i',
    hl.dsp.exec_cmd(PREFIX .. ' ' .. WINDOWSWITCHER),
    { description = 'Execute windowswitcher script' }
  )
  hl.bind(
    MAINMOD .. ' + B',
    hl.dsp.exec_cmd(PREFIX .. ' ' .. 'bookmark'),
    { repeating = true, description = 'Open bookmarks' }
  )
  hl.bind(
    MAINMOD .. ' + E',
    hl.dsp.exec_cmd(PREFIX .. ' ' .. 'emoji-picker'),
    { repeating = true, description = 'Open emoji picker' }
  )

  hl.bind(
    MAINMOD .. ' + M',
    hl.dsp.exec_cmd(PREFIX .. ' ' .. MOVE_WORKSPACE_TO_MONITOR),
    { repeating = true, description = 'Move active workspace to monitor' }
  )
  ------------------
  --- Scratchpads --
  ------------------
  --- AUDIO --
  -- binde = $mainMod, S, togglespecialworkspace, scratchpad_audiomanager
  hl.bind(
    MAINMOD .. ' + S',
    hl.dsp.exec_cmd(
      'if hyprctl clients | grep '
        .. AUDIOMANAGER
        .. '; then echo "scratchpad_audiomanager respawn not needed"; else '
        .. PREFIX
        .. ' '
        .. AUDIOMANAGER
        .. '; fi'
    ),
    { repeating = true, description = 'Open audio manager' }
  )
  --- BLUETOOTH --
  -- binde = $mainMod, D, togglespecialworkspace, scratchpad_bluetooth
  -- hl.bind(MAINMOD .. ' + D', function()
  --   hl.dsp.exec_cmd(
  --     'if hyprctl clients | grep '
  --       .. BLUETOOTHMANAGER
  --       .. '; then echo "scratchpad_bluetooth" respawn not needed; else '
  --       .. PREFIX
  --       .. ' '
  --       .. BLUETOOTHMANAGER
  --       .. '; fi'
  --   )
  --   hl.dsp.submap 'reset'
  -- end, { repeating = true, description = 'Open bluetooth manager' })
  --- TERMINAL --
  hl.bind(MAINMOD .. ' + F', function()
    hl.dispatch(hl.dsp.workspace.toggle_special 'scratchpad_terminal')
    hl.dispatch(
      hl.dsp.exec_cmd(
        'if hyprctl clients | grep scratchpad_term; then echo "scratchpad_term respawn not needed"; else '
          .. PREFIX
          .. ' '
          .. TERMINAL
          .. ' --class scratchpad_terminal; fi'
      )
    )
  end, { repeating = true, description = 'Open scratchpad terminal' })

  --- NETWORKMANAGER --
  -- binde = $mainMod, H, togglespecialworkspace, scratchpad_network
  hl.bind(
    MAINMOD .. ' + H',
    hl.dsp.exec_cmd(
      'if hyprctl clients | grep '
        .. NETWORKMANAGER
        .. '; then echo "scratchpad_network respawn not needed"; else '
        .. PREFIX
        .. ' '
        .. NETWORKMANAGER
        .. '; fi'
    ),
    { repeating = true, description = 'Open network manager' }
  )
  --- QUICK CAPTURE --
  hl.bind(MAINMOD .. ' + J', function()
    hl.dispatch(hl.dsp.workspace.toggle_special 'scratchpad_quick_capture')
    hl.dispatch(
      hl.dsp.exec_cmd 'if hyprctl clients | grep scratchpad_quick_capture; then echo "scratchpad_quick_capture respawn not needed"; else /usr/bin/quickcapture; fi'
    )
  end, { repeating = true, description = 'Open quick capture' })

  --- SCRATCHPAD1 & 2 --
  hl.bind(
    MAINMOD .. ' + K',
    hl.dsp.workspace.toggle_special 'scratchpad_1',
    { repeating = true, description = 'Open scratchpad workspace 1' }
  )

  hl.bind(
    MAINMOD .. ' + L',
    hl.dsp.workspace.toggle_special 'scratchpad_2',
    { repeating = true, description = 'Open scratchpad workspace 2' }
  )

  hl.bind(
    'catchall',
    hl.dsp.submap 'reset',
    { repeating = true, description = 'Exit submap' }
  )
  -- Move to scratchpads
  hl.bind(
    MAINMOD .. ' + SHIFT + K',
    hl.dsp.window.move { workspace = 'special:scratchpad_1' },
    { description = 'Move to scratchpad 1' }
  )
  hl.bind(
    MAINMOD .. ' + SHIFT + L',
    hl.dsp.window.move { workspace = 'special:scratchpad_2' },
    { description = 'Move to scratchpad 2' }
  )
end)
