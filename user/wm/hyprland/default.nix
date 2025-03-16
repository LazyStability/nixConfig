# This just serves as a transition from nix variables to hyprland
# inputs and userSettings are used to define global variables which get included before the actual hyprland config
# Mainly terminal, mainMod
# Or Setup specific stuff like monitors
{
  config,
  pkgs,
  inputs,
  userSettings,
  monitor,
  ...
}: {
  imports = [
    ./hyprpapaper.nix
    ./waybar.nix
  ];
  home.packages = with pkgs; [
    swaynotificationcenter
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
  programs.wofi.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false;
    settings = {
      # Setting up monitors, the third is a ghost monitor
      monitor = monitor;
      # Global variables set using nix variables
      "$EXIT" = "exec, uwsm stop";
      "$terminal" = userSettings.terminal;
      "$filemanager" = "yazi";
      "$menu" = "wofi --show drun";
      "$audiomanager" = "pwvucontrol";
      "$bluetoothmanager" = "blueberry";
      "$networkmanager" = "nm-connection-editor";
      "$monitor1" = "DP-2";
      "$monitor2" = "DP-1";
      "$browser" = "firefox-esr";
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
