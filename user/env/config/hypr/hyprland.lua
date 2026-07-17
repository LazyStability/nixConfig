EXIT = 'exec, loginctl terminate-user $(whoami)'
PREFIX = 'runapp'
AUDIOMANAGER = 'pwvucontrol'
BLUETOOTHMANAGER = 'blueberry'
BROWSER = 'firefox.desktop'
DISCORDCLIENT = 'vesktop'
FILEMANAGER = 'yazi'
HYPR_BINDS = '/usr/bin/hyprland-binds'
HYPR_LID_SWITCH = '/usr/bin/lid-switch-behaviour'
MAINMOD = 'SUPER'
MENU = 'fuzzel --launch-prefix="runapp "'
MONITOR1 = 'DP-1'
MONITOR2 = 'DP-2'
MOVE_WORKSPACE_TO_MONITOR = '/usr/bin/hyprland-move-workspace-to-monitor'
MUSIC_PLAYER = 'rmpc'
NETWORKMANAGER = 'networkmanager_dmenu'
TERMINAL = 'kitty'
WINDOWSWITCHER = '/usr/bin/hyprland-window-quickswitcher'

require 'input'
require 'keymaps'

require 'lookandfeel'
require 'windowrules'

require 'monitors'
hl.config {
  decoration = {
    blur = {
      enabled = true,
    },
    shadow = {
      color = 'rgba(24283b99)',
      enabled = true,
    },
  },
  general = {
    col = {
      active_border = 'rgb(41a6b5)',
      inactive_border = 'rgb(565f89)',
    },
  },
  group = {
    groupbar = {
      col = {
        active = 'rgb(41a6b5)',
        inactive = 'rgb(565f89)',
      },
      text_color = 'rgb(c0caf5)',
    },
    col = {
      border_active = 'rgb(41a6b5)',
      border_inactive = 'rgb(565f89)',
      border_locked_active = 'rgb(1abc9c)',
    },
  },
  misc = {
    background_color = 'rgb(24283b)',
    disable_autoreload = false,
    disable_hyprland_logo = true,
  },
  debug = {
    vfr = false,
  },
}
