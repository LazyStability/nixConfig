{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
  osConfig,
  ...
}:
let
  userTerminalPath = lib.path.append ../../user/Terminal userSettings.terminal;
in
{
  imports = [
    ../../user/shell
    ../../user/git
    ../../user/ssh

    userTerminalPath

    # Window managers
    # This includes either ./wm/hyprland or ./wm/gnome

    ../../user/home.nix
    ../../user/editor/nvim.nix
    ../../user/Gaming
    ../../user/filemanager/yazi.nix
    # ../../user/browser/firefox/firefox.nix
    ../../user/browser/zen/zen.nix
    ../../user/Messenger

    # inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.username = "me";
  home.homeDirectory = "/home/me";
}
