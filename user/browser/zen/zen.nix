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
    package =
      pkgs.wrapFirefox inputs.zen-browser.packages.${pkgs.system}.zen-browser-unwrapped
      (import ../firefox-wrapping.nix {
        isZen = true;
        inherit pkgs lib;
      });
    profiles = import ../firefox-profile.nix {
      inherit pkgs;
      userChrome = ''@import "Nebula/Nebula.css";'';
      userContent = ''@import "Nebula/Nebula-content.css";'';
    };
  };
  # Install a theme for zen
  home.file = {
    ".zen/me/chrome/Nebula".source =
      pkgs.fetchFromGitHub {
        owner = "JustAdumbPrsn";
        repo = "Nebula-A-Minimal-Theme-for-Zen-Browser";
        rev = "v1.5";
        sha256 = "0sgmqd97askm2q75yfp2x9mjypx0agjr35skb89080prqrm723iy";
      }
      + "/Nebula";
  };
}
