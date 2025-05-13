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

    ../../user/home.nix
    ../../user/editor/nvim.nix
    ../../user/Gaming
    # ../../user/browser/firefox/firefox.nix
    ../../user/browser/zen/zen.nix

    # inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.username = "me";
  home.homeDirectory = "/home/me";

  programs.kitty.enable = true;
  programs.yazi.enable = true;
}
