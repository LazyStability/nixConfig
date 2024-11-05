# This just serves as a transition from nix variables to hyprland
# inputs and userSettings are used to define global variables which get included before the actual hyprland config
# Mainly terminal, mainMod
# Or Setup specific stuff like monitors
{
  config,
  pkgs,
  inputs,
  userSettings,
  ...
}: {
  imports = [
    ./hyprpapaper.nix
    ./waybar.nix
  ];
  home.packages = with pkgs; [
    hyprshade
    hyprshot
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Setting up monitors, the third is a ghost monitor
      monitor = [
        "desc:Eizo Nanao Corporation EV2436W 42038045, 1920x1200@60,1280x0,1"
        "desc:Eizo Nanao Corporation S1901 45328108, 1280x1024@60,0x0,1"
        "Unknown-1,disabled"
      ];
      #   monitor = [
      #     ",preferred,auto,auto"
      #     "Unknown-1,disabled"
      # ];
      # Global variables set using nix variables
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
    ".config/hypr/hyprcursor.conf".source = ./hyprcursor.conf;
    ".config/hypr/hyprshade.toml".source = ./hyprshade.toml;
  };
}
