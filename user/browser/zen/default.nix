{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./zen-homemanager-module.nix
  ];
  stylix.targets.zen-browser.enable = false;
  programs.zen-browser = {
    package = pkgs.wrapFirefox inputs.zen-browser.packages.${pkgs.system}.zen-browser-unwrapped (
      import ../firefox-wrapping.nix {
        isZen = true;
        inherit pkgs lib;
      }
    );
    profiles = import ../firefox-profile.nix {
      inherit pkgs;
      # WARNING: natsumi does not support zen browser anymore
      # userChrome = ''@import "natsumi/natsumi.css";'';
      # userContent = ''@import "natsumi/natsumi-pages.css";'';
    };
  };
  # Install a theme for zen
  # WARNING: natsumi does not support zen browser anymore
  # home.file = {
  #   ".zen/me/chrome/natsumi".source = inputs.natsumi-theme + "/natsumi";
  #   ".zen/me/chrome/natsumi-config.css".source = inputs.natsumi-theme + "/natsumi-config.css";
  # };
}
