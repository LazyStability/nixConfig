{
  config,
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:
{
  imports = [
    ../../user/home.nix
    ../../user/Gaming

  ];
  home.username = "me";
  home.homeDirectory = "/home/me";

  programs.kitty.enable = true;
  programs.yazi.enable = true;
  programs.zen-browser.enable = true;
}
