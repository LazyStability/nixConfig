{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}:
let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  home.packages = [
    pkgs.wmctrl
    pkgs.gnomeExtensions.zen
    pkgs.gnomeExtensions.just-perfection
    pkgs.gnomeExtensions.tactile
    pkgs.gnomeExtensions.auto-move-windows
  ];

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      disabled-extensions = [
        "disabled"
        "light-style@gnome-shell-extensions.gcampax.github.com"
        "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        "places-menu@gnome-shell-extensions.gcampax.github.com"
        "drive-menu@gnome-shell-extensions.gcampax.github.com"
        "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com"
        "system-monitor@gnome-shell-extensions.gcampax.github.com"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "window-list@gnome-shell-extensions.gcampax.github.com"
        "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];
      enabled-extensions = [
        # add by uuid in metadata.json in github
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com" # Launches new instance of windows if one already exists
        "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
        "zen@le0.gs" # Adds direct window switch, mouse follows focus etc.
        "apps-menu@gnome-shell-extensions.gcampax.github.com" # Enables the App Menu Button in the task bar
      ];
      favorite-apps = [
        "zen.desktop"
        "org.gnome.Nautilus.desktop"
        "org.keepassxc.KeePassXC.desktop"
        "kitty.desktop"
        "vesktop.desktop"
        "thunderbird.desktop"
        "steam.desktop"
      ];
    };

    "org/gnome/shell/extensions/zen" = {
      enable-dbus-window-focus = true;
      enable-direct-window-switch = true;
      enable-mouse-follows-focus = true;
    };

    "org/gnome/desktop/input-sources" = {
      show-all-sources = true;
      sources = [
        (mkTuple [
          "xkb"
          "us"
        ])
        (mkTuple [
          "xkb"
          "de"
        ])
        (mkTuple [
          "xkb"
          "jp"
        ])
      ];
    };

    "org/gnome/desktop/interface" = {
      icon-theme = "Colloid";
      color-scheme = "prefer-dark";
      enable-hot-corners = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 10;
    };

    "org/gnome/mutter" = {
      experimental-features = [
        "variable-refresh-rate"
        "scale-monitor-framebuffer"
      ];
    };

    # Screenshot
    "org/gnome/shell/keybindings" = {
      show-screen-recording-ui = [ "disabled" ];
      screenshot = [ "disabled" ];
      show-screenshot-ui = [ "<Super><Shift>s" ];
      screenshot-window = [ "disabled" ];
    };

    "org/gnome/mutter/wayland/keybindings" = {
      restore-shortcuts = [ "disabled" ];
    };

    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ "disabled" ];
      toggle-quick-settings = [ "disabled" ];
      toggle-application-view = [ "disabled" ];
      toggle-message-tray = [ "disabled" ];
      toggle-overview = [ "disabled" ];

      switch-to-application-1 = [ "disabled" ];
      switch-to-application-2 = [ "disabled" ];
      switch-to-application-3 = [ "disabled" ];
      switch-to-application-4 = [ "disabled" ];
      switch-to-application-5 = [ "disabled" ];
      switch-to-application-6 = [ "disabled" ];
      switch-to-application-7 = [ "disabled" ];
      switch-to-application-8 = [ "disabled" ];
      switch-to-application-9 = [ "disabled" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      # Accessibility
      decrease-text-size = [ "disabled" ];
      toggle-contrast = [ "disabled" ];
      increase-text-size = [ "disabled" ];
      on-screen-keyboard = [ "disabled" ];
      screenreader = [ "disabled" ];
      magnifier = [ "disabled" ];
      magnifier-zoom-in = [ "disabled" ];
      magnifier-zoom-out = [ "disabled" ];
      # Launchers
      home = [ "disabled" ];
      calculator = [ "disabled" ];
      email = [ "disabled" ];
      help = [ "disabled" ];
      www = [ "disabled" ];
      search = [ "disabled" ];
      control-center = [ "disabled" ];
      # System
      screensaver = [ "<Super><Shift>n" ];
      logout = [ "disabled" ];
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      # Navigation
      show-desktop = [ "disabled" ];
      move-to-monitor-down = [ "disabled" ];
      move-to-monitor-left = [ "disabled" ];
      move-to-monitor-right = [ "disabled" ];
      move-to-monitor-up = [ "disabled" ];
      move-to-workspace-left = [ "disabled" ];
      move-to-workspace-right = [ "disabled" ];
      move-to-workspace-down = [ "disabled" ];
      move-to-workspace-up = [ "disabled" ];
      move-to-workspace-last = [ "disabled" ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      switch-to-workspace-10 = [ "<Super>0" ];
      switch-to-workspace-11 = [ "disabled" ];
      switch-to-workspace-12 = [ "disabled" ];
      switch-to-switch-applications = [ "<Super>Tab" ];
      switch-to-switch-panels = [ "disabled" ];
      switch-to-cycle-panels = [ "disabled" ];
      switch-to-workspace-last = [ "disabled" ];
      switch-to-workspace-left = [ "disabled" ];
      switch-to-workspace-right = [ "disabled" ];
      move-to-workspace-1 = [ "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      move-to-workspace-5 = [ "<Super><Shift>5" ];
      move-to-workspace-6 = [ "<Super><Shift>6" ];
      move-to-workspace-7 = [ "<Super><Shift>7" ];
      move-to-workspace-8 = [ "<Super><Shift>8" ];
      move-to-workspace-9 = [ "<Super><Shift>9" ];
      move-to-workspace-10 = [ "<Super><Shift>0" ];
      move-to-workspace-11 = [ "disabled" ];
      move-to-workspace-12 = [ "disabled" ];
      cycle-windows = [ "disabled" ];
      switch-windows = [ "disabled" ];
      cycle-group = [ "disabled" ];
      switch-window-backward = [ "disabled" ];
      switch-group = [ "disabled" ];
      # System
      panel-run-dialog = [ "disabled" ];
      # Typing
      switch-input-source = [ "<Super>space" ];
      switch-input-source-backward = [ "<Shift><Super>space" ];
      # Windows
      activate-window-menu = [ "disabled" ];
      close = [ "<Super>q" ];
      minimize = [ "disabled" ];
      lower = [ "disabled" ];
      maximize = [ "disabled" ];
      maximize-horizontally = [ "disabled" ];
      maximize-vertically = [ "disabled" ];
      begin-move = [ "disabled" ];
      raise = [ "disabled" ];
      raise-or-lower = [ "disabled" ];
      begin-resize = [ "disabled" ];
      unmaximize = [ "disabled" ];
      toggle-maximized = [ "disabled" ];
      toggle-on-all-workspaces = [ "disabled" ];
      toggle-fullscreen = [ "<Super>z" ];
    };

    #############
    # Launchers #
    #############

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Launch Terminal";
      command = userSettings.terminal;
      binding = "<Super>Return";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Launch Home Folder";
      command = "${userSettings.terminal} zsh -fdc yazi";
      binding = "<Super>e";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "Auto type";
      command = "dbus-send --session --type=method_call --dest=org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.KeePassXC.MainWindow.requestGlobalAutoType";
      binding = "<Super>r";
    };
  };
}
