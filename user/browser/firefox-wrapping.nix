{
  pkgs,
  lib,
}:
{
  # Allows communication between the browser and other apps
  nativeMessagingHosts = [
    # Gnome shell native connector
    #TODO: make this an option with nix module system
    # pkgs.gnome-browser-connector
    # pkgs.keepassxc
  ];
  # Enforced on all profiles
  # See here all available fields
  # https://github.com/mozilla/policy-templates/blob/master/linux/policies.json
  # And what they do
  # https://mozilla.github.io/policy-templates
  extraPolicies = {
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
    ExtensionSettings =
      with builtins;
      let
        extension = shortId: uuid: {
          name = uuid;
          value = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
            installation_mode = "force_installed";
          };
        };
      in
      listToAttrs ([
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
        (extension "vimium-c" "vimium-c@gdh1995.cn")

        # zotero is not in firefox store
        {
          name = "zotero@chnm.gmu.edu";
          value = {
            install_url = "https://www.zotero.org/download/connector/dl?browser=firefox";
            install_mode = "normal_installed";
          };
        }
      ]
      # ++
      # zen extensions
      # WARN: This extension makes it hard to read some websites
      # lib.optional isZen (extension "transparent_zen" "{91aa3897-2634-4a8a-9092-279db23a7689}")
      );

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
}
