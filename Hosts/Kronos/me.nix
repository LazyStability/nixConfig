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
  monitors = [
    {
      name = "DP-2";
      enable = true;
      mode = "1920x1200";
      position = "1280x0";
      rate = "60";
      primary = true;
    }
    {
      name = "DP-1";
      enable = true;
      mode = "1280x1024";
      position = "0x0";
      rate = "60.00";
    }
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
      monitor = monitors;
      inputs = inputs;
      pkgs = pkgs;
      userSettings = userSettings;
      config = config;
      lib = lib;
      osConfig = osConfig;
    })

    ../../user/home.nix
    ../../user/editor/nvim.nix
    ../../user/Gaming
    ../../user/filemanager/yazi.nix
    ../../user/browser/zen/zen.nix
    # ../../user/browser/firefox/firefox.nix
    ../../user/dataLinks.nix
    ../../user/Messenger
    ../../user/Scripts

    # inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.username = "me";
  home.homeDirectory = "/home/me";

}
