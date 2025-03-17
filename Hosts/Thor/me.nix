{
  config,
  pkgs,
  lib,
  pkgs-stable,
  inputs,
  userSettings,
  ...
}: let
  userTerminalPath = lib.path.append ../../user/Terminal userSettings.terminal;
  WmConfig = lib.path.append ../../user/wm userSettings.wm;
  monitor = [
    "DP-1, 2560x1440@60, 0x0, 1"
    "Unknown-1,disabled"
  ];
in {
  imports = [
    ../../user/shell
    ../../user/git
    ../../user/ssh

    userTerminalPath

    # Window managers
    # This includes either ./wm/hyprland or ./wm/gnome

    (import WmConfig {
      monitor = monitor;
      inputs = inputs;
      pkgs = pkgs;
      userSettings = userSettings;
      config = config;
    })

    ../../user/home.nix
    ../../user/editor/nvim.nix
    ../../user/Gaming
    ../../user/filemanager/yazi.nix
    ../../user/browser/firefox/firefox.nix
    ../../user/browser/zen/zen.nix
    ../../user/Messenger
    ../../user/Scripts

    # inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.username = "me";
  home.homeDirectory = "/home/me";
}
