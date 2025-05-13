{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
  osConfig,
  ...
}:
{
  imports = [
    ../../user/shell
    ../../user/git
    ../../user/ssh

    ../../user/home.nix
    ../../user/editor/nvim.nix
    ../../user/Gaming
    # ../../user/browser/firefox/firefox.nix
    ../../user/browser/zen/zen.nix
    ../../user/Messenger

    # inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.username = "me";
  home.homeDirectory = "/home/me";

  programs.kitty.enable = true;
  programs.yazi.enable = true;
}
