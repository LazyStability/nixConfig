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
        isZen = true;
        inherit pkgs lib;
      });
    profiles = import ../firefox-profile.nix {
      inherit pkgs;
    };
  };
}
