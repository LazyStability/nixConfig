{
  pkgs,
  inputs,
  lib,
  ...
}: {
  home.packages = let
    zen-browser = pkgs.wrapFirefox inputs.zen-browser.packages.${pkgs.system}.zen-browser-unwrapped (import ../firefox-policies.nix {
      pkgs = pkgs;
      lib = lib;
    });
  in [
    zen-browser
  ];
}
