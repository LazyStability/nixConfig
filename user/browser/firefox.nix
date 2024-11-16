{
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    # Use the ESR for more policies for example search engines
    package = pkgs.firefox-esr;

    # Enforced on all profiles
    # See here all available fields
    # https://github.com/mozilla/policy-templates/blob/master/linux/policies.json
    # And what they do
    # https://mozilla.github.io/policy-templates
    policies = {
      AppAutoUpdate = true;
      ManualAppUpdateOnly = false;
      ManualAppUpdateOnly_comment = "Change to true to disable auto-updates.";

      DisableBuiltinPDFViewer = true;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      DisableFireFoxScreenshots = true;
      DisableForgetButton = true;
      DisableMasterPasswordCreation = true;
      DisableFeedbackCommands = true;
      DisablePocket = true;
      DisableSetDesktopBackground = true;
      DisableFormHistory = true;
      DisableTelemetry = true;
      DisableDeveloperTools = false;

      # Deletes everything on shutdown Cookies, websites, etc.
      SanitizeOnShutdown = true;

      HttpsOnlyMode = "force_enabled";
      # Find a good provider here
      # https://www.privacyguides.org/en/dns/
      # Or TODO: Host pihole yourself
      DNSOverHTTPS = {
        Enabled = true;
        ProviderURL = "https://dns.quad9.net/dns-query";
        # Argh I am not sure
        Locked = true;
      };

      # I use an extern password manager
      OfferToSaveLogins = false;
      PostQuantumKeyAgreementEnabled = true;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      EncryptedMediaExtensions = {
        Enabled = true;
        Locked = true;
      };

      # Convenience
      DontCheckDefaultBrowser = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";

      FirefoxHome = {
        Search = true;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = true;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };

      # Only possible if you are using Firefox ESR
      SearchEngines = {
        PreventInstalls = true;
        # Use your search engine of choice
        Default = "DuckDuckGo";
        Remove = [
          "Amazon.com"
          "eBay"
          "Bing"
          "Google"
        ];
        Add = [
          # Adds a search engine, Name and URLTemplate are mandatory options
        ];
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };
      PDFjs = {
        Enabled = false; # There is no legitimate reason for js in PDFs
        EnablePermissions = false;
      };
      # On the topic of pdfs, we disabled the pdf viewer earlier above so we need to use an external one
      Handlers = {
        mimeTypes."application/pdf".action = "saveToDisk";
      };
      extensions = {
        pdf = {
          action = "useHelperApp";
          ask = true;
          handlers = [
            {
              # TODO: Use template pdf viewer instead of hardcoding okular
              name = "Pdf Viewer";
              path = "${pkgs.kdePackages.okular}/bin/okular";
            }
          ];
        };
      };

      ################
      ## Extensions ##
      ################

      # Helper function copied from https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/17
      ExtensionSettings = with builtins; let
        extension = shortId: uuid: {
          name = uuid;
          value = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
      in
        listToAttrs [
          # To add additional extensions, find it on addons.mozilla.org, find
          # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
          # The UUID can be foun after installing it in
          # about:debugging#/runtime/this-firefox

          # These three are recommended by Arkenfox
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "multi-account-containers" "@testpilot-containers")
          (extension "skip-redirect" "skipredirect@sblask")

          # My password manager
          (extension "keepassxc-browser" "keepassxc-browser@keepassxc.org")
        ];

      # Very nice policy, enforces stuff on extensions, which allows us to configure them
      # Taken from https://discourse.nixos.org/t/declare-firefox-extensions-and-settings/36265/26
      "3rdparty".Extensions = {
        "uBlock0@raymondhill.net".adminSettings = {
          userSettings = rec {
            uiTheme = "dark";
            uiAccentCustom = true;
            uiAccentCustom0 = "#8300ff";
            cloudStorageEnabled = lib.mkForce false; # Security liability?
            importedLists = [
              "https://filters.adtidy.org/extension/ublock/filters/3.txt"
              # This is recommended by arkenfox
              "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
            ];
            externalLists = lib.concatStringsSep "\n" importedLists;
          };
          selectedFilterLists = [
            "CZE-0"
            "adguard-generic"
            "adguard-annoyance"
            "adguard-social"
            "adguard-spyware-url"
            "easylist"
            "easyprivacy"
            "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
            "plowe-0"
            "ublock-abuse"
            "ublock-badware"
            "ublock-filters"
            "ublock-privacy"
            "ublock-quick-fixes"
            "ublock-unbreak"
            "urlhaus-1"
          ];
        };
      };
    };

    ##############
    ## Profiles ##
    ##############

    profiles.me = {
      name = "me"; # name as listed in about:profiles
      isDefault = true; # can be omitted; true if profile ID is 0
      id = 0; # 0 is the default profile; see also option "isDefault"
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
        extensions = [];
      };
      search = {
        force = true;
        engines = {
          "Nix Packages" = {
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@np"];
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
            definedAliases = ["@no"];
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
            definedAliases = ["@hm"];
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
            definedAliases = ["@gh"];
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
        };
      };
    };
  };
}
