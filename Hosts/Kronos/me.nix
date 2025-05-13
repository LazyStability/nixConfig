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
    ../../user/browser/zen/zen.nix
    # ../../user/browser/firefox/firefox.nix

    # inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.username = "me";
  home.homeDirectory = "/home/me";
  myHomeModules = {
    dataLinks.enable = true;
    gaming.screenRecording = {
      enable = true;
    };
  };
  programs.kitty.enable = true;
  programs.yazi.enable = true;
}
