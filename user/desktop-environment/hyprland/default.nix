# This just serves as a transition from nix variables to hyprland
# inputs and userSettings are used to define global variables which get included before the actual hyprland config
# Mainly terminal, mainMod
# Or Setup specific stuff like monitors
{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.myHomeModules.desktopEnvironment;
  monitor-name-list = lib.lists.forEach cfg.monitors (Monitor: Monitor.name);
  monitor-count = builtins.length monitor-name-list;
  monitor-1 = builtins.elemAt monitor-name-list 0;
  monitor-2 =
    if (monitor-count >= 2) then
      (builtins.elemAt monitor-name-list 1)
    else
      (builtins.elemAt monitor-name-list 0);
in
{
  imports = [
    ./hyprpapaper.nix
    ./waybar.nix
    ./swaync.nix
    ./hyprlock.nix
  ];

  config = lib.mkIf (config.myHomeModules.desktopEnvironment.select == "hyprland") {
    home.packages =
      with pkgs;

      [
        networkmanager_dmenu
        pwvucontrol
        hyprsunset
        hyprshade
        hyprshot
      ];
    # choose gtk theme
    gtk = {
      enable = true;

      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };
    # Enable all the utils
    programs = {
      fuzzel.enable = true;
      waybar.enable = true;
      hyprlock.enable = true;
    };
    services = {
      hyprpaper.enable = lib.mkForce (!cfg.powerSavingMode.enable);
      swaync.enable = true;
    };

    # Needed for dual monitor setup to tell xwayland, which steam relies upon which monitor is the correct one to use
    systemd.user.services.Primary-Monitor = {
      Unit = {
        description = "Set main monitor";
        After = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart =
          let
            script = pkgs.writeShellApplication {
              name = "mainmon";
              runtimeInputs = [ pkgs.xorg.xrandr ];
              text = ''
                xrandr --output ${monitor-1} --primary
              '';
            };

          in
          "${script}/bin/mainmon";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;
      systemd.enable = false;
      settings =
        let
          monitor-hypr = lib.lists.forEach cfg.monitors (
            Monitor:
            (Monitor.name + "," + Monitor.mode + "@" + Monitor.rate + "," + Monitor.position + "," + "1")
          );

          windowswitcher = lib.getExe (
            pkgs.callPackage ../../scripts/window-quickswitcher.nix { config = config; }
          );
          move-workspace-to-monitor = lib.getExe (
            pkgs.callPackage ../../scripts/move-workpace-to-monitor.nix {
              config = config;
            }
          );
          hypr-binds = lib.getExe (pkgs.callPackage ../../scripts/hypr-binds.nix { config = config; });
          hypr-lid-switch = lib.getExe (
            pkgs.callPackage ../../scripts/hyprland-switch-behaviour.nix { config = config; }
          );
        in
        {
          # Setting up monitors, the third is a ghost monitor
          monitor = monitor-hypr;
          # Global variables set using nix variables
          "$EXIT" = "exec, loginctl terminate-user $(whoami)";
          # Use the os config flag found here
          # This ensures all programms are started by uwsm if, it is active
          # REF: https://github.com/nix-community/home-manager/issues/393#issuecomment-1259996423
          "$PREFIX" = lib.optionalString osConfig.programs.hyprland.withUWSM "uwsm app --";
          "$terminal" = "kitty";
          "$filemanager" = "yazi";
          "$music-player" = "rmpc";
          "$menu" =
            if osConfig.programs.hyprland.withUWSM && config.programs.wofi.enable then
              "uwsm app -- $(wofi --show drun --define=drun-print_desktop_file=true)"
            else if osConfig.programs.hyprland.withUWSM && config.programs.fuzzel.enable then
              "fuzzel --launch-prefix=\"uwsm app -- \""
            else if config.programs.fuzzel.enable then
              "fuzzel --show drun"
            else if config.programs.wofi.enable then
              "wofi --show drun"
            else
              builtins.throw "No supported applauncher actived. Use programs.wofi.enable or programs.fuzzel.enable.";
          "$audiomanager" = "pwvucontrol";
          "$bluetoothmanager" = "blueberry";
          "$networkmanager" = "networkmanager_dmenu";
          "$monitor1" = monitor-1;
          "$monitor2" = monitor-2;
          "$browser" =
            if config.programs.floorp.enable then
              "floorp.desktop"
            else if config.programs.firefox.enable then
              "firefox.desktop"
            else
              "brave.desktop";
          "$discordClient" = "vesktop";

          # Hyprland Scripts
          "$hypr-binds" = hypr-binds;
          "$hypr-lid-switch" = hypr-lid-switch;
          "$move-workspace-to-monitor" = move-workspace-to-monitor;
          "$windowswitcher" = windowswitcher;

          # Sets "Windows" key as main modifier
          "$mainMod" = "SUPER";
          #Energy savings
          #See https://wiki.hypr.land/Configuring/Performance/#how-do-i-make-hyprland-draw-as-little-power-as-possible-on-my-laptop
          decoration = {
            shadow.enabled = !cfg.powerSavingMode.enable;
            blur.enabled = !cfg.powerSavingMode.enable;
          };
          misc = {
            vfr = cfg.powerSavingMode.enable;
            disable_autoreload = cfg.powerSavingMode.enable;
          };
        };
      # Source the rest of the config
      # extraConfig = builtins.readFile ./hyprland.conf;
      extraConfig = ''
        source ~/.config/hypr/autostart.conf
        source ~/.config/hypr/input.conf
        source ~/.config/hypr/keymaps.conf
        source ~/.config/hypr/lookandfeel.conf
        source ~/.config/hypr/windowrules.conf
      '';
    };
  };
}
