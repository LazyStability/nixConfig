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

  ];
  home.username = "me";
  home.homeDirectory = "/home/me";

  programs.kitty.enable = true;
  programs.yazi.enable = true;
  programs.zen-browser.enable = true;
}
