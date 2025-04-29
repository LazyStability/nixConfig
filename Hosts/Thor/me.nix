{
  config,
  pkgs,
  lib,
  pkgs-stable,
  inputs,
  userSettings,
  osConfig,
  ...
}:
let
  userTerminalPath = lib.path.append ../../user/Terminal userSettings.terminal;
  WmConfig = lib.path.append ../../user/wm userSettings.wm;
  monitor = [
    {
      name = "DP-1";
      enable = true;
      mode = "2560x1440";
      position = "0x0";
      rate = "60.00";
    }
  ];
in
{
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
      lib = lib;
      userSettings = userSettings;
      config = config;
      osConfig = osConfig;
    })

    ../../user/home.nix
    ../../user/Video/mpv.nix
    ../../user/Music/mpd.nix
    ../../user/editor/nvim.nix
    ../../user/Gaming
    ../../user/filemanager/yazi.nix
    # ../../user/browser/firefox/firefox.nix
    ../../user/browser/zen/zen.nix
    ../../user/Messenger
    ../../user/Scripts

    # inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.username = "me";
  home.homeDirectory = "/home/me";
}
