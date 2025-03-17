{
  config,
  pkgs,
  lib,
  pkgs-stable,
  inputs,
  userSettings,
  ...
}:
let
  userTerminalPath = lib.path.append ../../user/Terminal userSettings.terminal;
  monitor = [
    "desc:Eizo Nanao Corporation EV2436W 42038045, 1920x1200@60,1280x0,1"
    "desc:Eizo Nanao Corporation S1901 45328108, 1280x1024@60,0x0,1"
    "Unknown-1,disabled"
  ];
  WmConfig = lib.path.append ../../user/wm userSettings.wm;
in
{
  imports = [
    ../../user/shell
    ../../user/git
    ../../user/ssh

    userTerminalPath

    # Window managers
    # This includes either ./wm/hyprland or ./wm/gnome or ./wm/KDE
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
    ../../user/browser/zen/zen.nix
    ../../user/browser/firefox/firefox.nix
    ../../user/dataLinks.nix
    ../../user/Messenger
    ../../user/Scripts

    # inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.username = "me";
  home.homeDirectory = "/home/me";
}
