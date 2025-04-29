# This just serves as a transition from nix variables to hyprland
# inputs and userSettings are used to define global variables which get included before the actual hyprland config
# Mainly terminal, mainMod
# Or Setup specific stuff like monitors
{
  osConfig,
  config,
  pkgs,
  monitor,
  lib,
  ...
}:
let
  monitor-name-list = lib.lists.forEach monitor (Monitor: Monitor.name);
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
  ];
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
  # Enable menu
  programs.fuzzel.enable = true;

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
        monitor-hypr = lib.lists.forEach monitor (
          Monitor:
          (Monitor.name + "," + Monitor.mode + "@" + Monitor.rate + "," + Monitor.position + "," + "1")
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
          else
            "wofi --show drun";
        "$audiomanager" = "pwvucontrol";
        "$bluetoothmanager" = "blueberry";
        "$networkmanager" = "networkmanager_dmenu";
        "$monitor1" = monitor-1;
        "$monitor2" = monitor-2;
        "$browser" = "zen";
        "$discordClient" = "vesktop";

        # Sets "Windows" key as main modifier
        "$mainMod" = "SUPER";
      };
    # Source the rest of the config
    extraConfig = ''
      source = ~/.config/hypr/input.conf
      source = ~/.config/hypr/looks.conf
      source = ~/.config/hypr/windowsWorkspace.conf
      source = ~/.config/hypr/autostart.conf
      # source = ~/.config/hypr/hyprcursor.conf
      source = ~/.config/hypr/test.conf
    '';
  };
  # Symlinks the rest of the config to the ~/.config/hypr directory
  home.file = {
    ".config/hypr/input.conf".source = ./input.conf;
    ".config/hypr/looks.conf".source = ./looks.conf;
    ".config/hypr/windowsWorkspace.conf".source = ./windowsWorkspace.conf;
    ".config/hypr/autostart.conf".source = ./autostart.conf;
    # ".config/hypr/hyprcursor.conf".source = ./hyprcursor.conf;
    # ".config/hypr/hyprshade.toml".source = ./hyprshade.toml;
  };
}
