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
hl.bind(
  MAINMOD .. ' + O',
  hl.dsp.layout '',
  { description = 'Change spliting' }
)

-- LDUR
hl.bind(
  MAINMOD .. ' + h',
  hl.dsp.focus { direction = 'left' },
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
  hl.dsp.focus { direction = 'right' },
  { description = 'Switch to window right' }
)

-- Switch windows
hl.bind(
  MAINMOD .. ' + SHIFT + h',
  hl.dsp.window.swap { direction = 'l' },
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
  hl.dsp.window.swap { direction = 'r' },
  { description = 'Switch to window right' }
)

-- Switch workspaces with mainMod + [0-9]
hl.bind(
  MAINMOD .. ' + 1',
  hl.dsp.focus { workspace = 1 },
  { description = 'Switch to workspace 1' }
)
hl.bind(
  MAINMOD .. ' + 2',
  hl.dsp.focus { workspace = 2 },
  { description = 'Switch to workspace 2' }
)
hl.bind(
  MAINMOD .. ' + 3',
  hl.dsp.focus { workspace = 3 },
  { description = 'Switch to workspace 3' }
)
hl.bind(
  MAINMOD .. ' + 4',
  hl.dsp.focus { workspace = 4 },
  { description = 'Switch to workspace 4' }
)
hl.bind(
  MAINMOD .. ' + 5',
  hl.dsp.focus { workspace = 5 },
  { description = 'Switch to workspace 5' }
)
hl.bind(
  MAINMOD .. ' + 6',
  hl.dsp.focus { workspace = 6 },
  { description = 'Switch to workspace 6' }
)
hl.bind(
  MAINMOD .. ' + 7',
  hl.dsp.focus { workspace = 7 },
  { description = 'Switch to workspace 7' }
)
hl.bind(
  MAINMOD .. ' + 8',
  hl.dsp.focus { workspace = 8 },
  { description = 'Switch to workspace 8' }
)
hl.bind(
  MAINMOD .. ' + 9',
  hl.dsp.focus { workspace = 9 },
  { description = 'Switch to workspace 9' }
)
hl.bind(
  MAINMOD .. ' + 0',
  hl.dsp.focus { workspace = 10 },
  { description = 'Switch to workspace 10' }
)

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(
  MAINMOD .. ' + SHIFT + 1',
  hl.dsp.window.move { workspace = 1 },
  { description = 'Move to workspace 1' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + 2',
  hl.dsp.window.move { workspace = 2 },
  { description = 'Move to workspace 2' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + 3',
  hl.dsp.window.move { workspace = 3 },
  { description = 'Move to workspace 3' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + 4',
  hl.dsp.window.move { workspace = 4 },
  { description = 'Move to workspace 4' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + 5',
  hl.dsp.window.move { workspace = 5 },
  { description = 'Move to workspace 5' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + 6',
  hl.dsp.window.move { workspace = 6 },
  { description = 'Move to workspace 6' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + 7',
  hl.dsp.window.move { workspace = 7 },
  { description = 'Move to workspace 7' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + 8',
  hl.dsp.window.move { workspace = 8 },
  { description = 'Move to workspace 8' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + 9',
  hl.dsp.window.move { workspace = 9 },
  { description = 'Move to workspace 9' }
)
hl.bind(
  MAINMOD .. ' + SHIFT + 0',
  hl.dsp.window.move { workspace = 10 },
  { description = 'Move to workspace 10' }
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
  MAINMOD .. ' + S',
  hl.dsp.submap 'swap',
  { description = 'Enter swap submap' }
)
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

--------------------
--- swap submap --
--------------------

hl.define_submap('swap', function()
  -- Set repeatable binds for resizing the active window.
  hl.bind(
    'h',
    hl.dsp.window.swap { direction = 'l' },
    { repeating = true, description = 'Switch to window left' }
  )
  hl.bind(
    'j',
    hl.dsp.window.swap { direction = 'd' },
    { repeating = true, description = 'Switch to window down' }
  )
  hl.bind(
    'k',
    hl.dsp.window.swap { direction = 'u' },
    { repeating = true, description = 'Switch to window up' }
  )
  hl.bind(
    'l',
    hl.dsp.window.swap { direction = 'r' },
    { repeating = true, description = 'Switch to window right' }
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
end)
