{
  config,
  osConfig,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  stylix.targets.firefox.enable = false;
  programs.firefox = {
    # Use the ESR for more policies for example search engines
    package = null;
    profiles = (
      lib.mkMerge [
        (import ../firefox-profile.nix {
          inherit pkgs;
          userChrome = ''@import "natsumi/natsumi.css";'';
          userContent = ''@import "natsumi/natsumi-pages.css";'';
        })
        (import ../firefox-vertical-tabs.nix { })

        (import ../natsumi-settings.nix { })
        {
          me.settings = {
            "natsumi.browser.type" = "firefox";
          };
        }
      ]
    );
  };
  # Install a theme for firefox
  home.file = (
    lib.mkIf config.programs.firefox.enable {
      ".mozilla/firefox/me/chrome/natsumi".source = inputs.natsumi-theme + "/natsumi";
      ".mozilla/firefox/me/chrome/natsumi-config.css".source =
        inputs.natsumi-theme + "/natsumi-config.css";
    }
  );
}
