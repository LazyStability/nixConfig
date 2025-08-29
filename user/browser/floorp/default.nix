{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  stylix.targets.floorp.enable = false;
  stylix.targets.firefox.enable = false;
  programs.floorp = {
    # Use the ESR for more policies for example search engines
    package = (
      lib.mkDefault (
        pkgs.wrapFirefox pkgs.floorp-unwrapped (
          import ../firefox-wrapping.nix {
            inherit pkgs lib;
          }
        )
      )
    );
    profiles = (
      lib.mkMerge [
        (import ../firefox-profile.nix {
          inherit pkgs;
          userChrome = ''@import "natsumi/natsumi.css";'';
          userContent = ''@import "natsumi/natsumi-pages.css";'';
        })
        (import ../firefox-vertical-tabs.nix { })
      ]
    );
  };
  # Install a theme for firefox
  home.file = {
    ".floorp/me/chrome/natsumi".source = inputs.natsumi-theme + "/natsumi";
    ".floorp/me/chrome/natsumi-config.css".source = inputs.natsumi-theme + "/natsumi-config.css";
  };
}
