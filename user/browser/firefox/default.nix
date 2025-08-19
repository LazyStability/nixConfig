{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  stylix.targets.firefox.enable = false;
  programs.firefox = {
    # Use the ESR for more policies for example search engines
    package = pkgs.wrapFirefox pkgs.firefox-esr-unwrapped (
      import ../firefox-wrapping.nix {
        inherit pkgs lib;
        isZen = false;
      }
    );
    profiles = import ../firefox-profile.nix {
      inherit pkgs;
      userChrome = ''@import "natsumi/natsumi.css";'';
      userContent = ''@import "natsumi/natsumi-pages.css";'';
    };
  };
  # Install a theme for firefox
  home.file = {
    ".mozilla/firefox/me/chrome/natsumi".source = inputs.natsumi-theme + "/natsumi";
    ".mozilla/firefox/me/chrome/natsumi-config.css".source =
      inputs.natsumi-theme + "/natsumi-config.css";
  };
}
