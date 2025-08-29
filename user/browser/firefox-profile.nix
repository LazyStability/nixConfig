{
  pkgs,
  userChrome ? "",
  userContent ? "",
  ...
}:
{
  ##############
  ## Profiles ##
  ##############

  me = {
    name = "me"; # name as listed in about:profiles
    isDefault = true; # can be omitted; true if profile ID is 0
    id = 0; # 0 is the default profile; see also option "isDefault"
    userChrome = userChrome;
    userContent = userContent;
    settings = {
      # specify profile-specific preferences here; check about:config for options
      "browser.contentblocking.category" = {
        Value = "strict";
        Status = "locked";
      };
      # Was enabled on default on my maschine but just to be save
      # Short form uses different processes to seperate memory blocks which prevents malicous websites access to your other tabs, at least in theory
      # https://hacks.mozilla.org/2021/05/introducing-firefox-new-site-isolation-security-architecture/
      "fission.autostart" = true;

      ## Arkenfox Section 0200
      "geo.provider.use_geoclue" = false;

      ## Arkenfox Section 0300
      "extensions.getAddons.showPane" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "browser.discovery.enabled" = false;
      "browser.shopping.experience2023.enabled" = false;

      ## Arkenfox Section 0330  & 0340 is basicly done up in policies
      ## 0360
      "captivedetect.canonicalURL" = "";
      "network.captive-portal-service.enabled" = false;
      "network.connectivity-service.enabled" = false;

      "browser.startup.homepage" = "https://nixos.org";
      "browser.newtabpage.pinned" = [
        {
          title = "NixOS";
          url = "https://nixos.org";
        }
      ];
      extensions = [ ];
    };
    search = {
      force = true;
      default = "ddg";
      engines = {
        "Nix Packages" = {
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
        "Nix Options" = {
          definedAliases = [ "@no" ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
        "Home manager" = {
          definedAliases = [ "@hm" ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          urls = [
            {
              template = "https://home-manager-options.extranix.com";
              params = [
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };

        "Github" = {
          definedAliases = [ "@gh" ];
          icon = "";
          urls = [
            {
              template = "https://github.com/search";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
        "google".metaData.hidden = true;
        "bing".metaData.hidden = true;
      };
    };
  };
}
