{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./zen-homemanager-module.nix
  ];
  programs.zen-browser = {
    enable = true;
    # Use the ESR for more policies for example search engines
    package =
      pkgs.wrapFirefox inputs.zen-browser.packages.${pkgs.system}.zen-browser-unwrapped
      (import ../firefox-wrapping.nix {
        lib = lib;
        pkgs = pkgs;
      });
    profiles = import ../firefox-profile.nix {pkgs = pkgs;};
  };
}
