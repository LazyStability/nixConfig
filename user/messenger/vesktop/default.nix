{
  pkgs,
  ...
}:
let
  loading-gif = ./start-up.gif;
in
{

  services.mpd-discord-rpc = {
    enable = false;
  };
  programs.vesktop = {
    enable = true;
    package = pkgs.vesktop.overrideAttrs (old: {
      buildInputs = [ pkgs.curl ] ++ old.buildInputs;
      src = pkgs.fetchFromGitHub {
        owner = old.src.owner;
        repo = old.src.repo;
        rev = old.src.rev;
        hash = "sha256-CEkXs1fgYRlPiH6Qh+RUdVO4PbZ0P5do06m0x3K2KUc=";
        postFetch = ''
          cp ${loading-gif} $out/static/shiggy.gif
        '';
      };
    });
    settings = {
      appBadge = false;
      checkUpdates = false;
      customTitleBar = false;
      disableMinSize = true;
      staticTitle = true;
      hardwareAcceleration = true;
      discordBranch = "stable";
      minimizeToTray = false;
      tray = false;
      arRPC = true;
      splashColor = "rgb(223, 224, 226)";
      splashBackground = "rgba(0, 0, 0, 0)";
      transparencyOption = "epic banana";
      spellCheckLanguages = [
        "de"
        "de-DE"
      ];
    };
    vencord = {
      # themes = "";
      settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        useQuickCss = true;
        themeLinks = [ ];
        enabledThemes = [
          "stylix.theme.css"
        ];
        enableReactDevtools = false;
        frameless = false;
        transparent = false;
        winCtrlQ = false;
        disableMinSize = false;
        winNativeTitleBar = false;
        plugins = {
          CommandsAPI = {
            enabled = true;
          };
          MessageAccessoriesAPI = {
            enabled = true;
          };
          MessageEventsAPI = {
            enabled = true;
          };
          UserSettingsAPI = {
            enabled = true;
          };
          AnonymiseFileNames = {
            enabled = true;
          };
          BetterRoleContext = {
            enabled = true;
          };
          CallTimer = {
            enabled = true;
            format = "stopwatch";
          };
          ClearURLs = {
            enabled = true;
          };
          CrashHandler = {
            enabled = true;
          };
          FakeNitro = {
            enabled = true;
            enableStickerBypass = true;
            enableStreamQualityBypass = true;
            enableEmojiBypass = true;
            transformEmojis = true;
            transformStickers = true;
            transformCompoundSentence = false;
          };
          FriendsSince = {
            enabled = true;
          };
          GameActivityToggle = {
            enabled = true;
            oldIcon = false;
          };
          MemberCount = {
            enabled = true;
            memberList = true;
            toolTip = true;
          };
          NoTypingAnimation = {
            enabled = true;
          };
          OnePingPerDM = {
            enabled = true;
            channelToAffect = "both_dms";
            allowMentions = false;
            allowEveryone = false;
          };
          ServerInfo = {
            enabled = true;
          };
          ShowHiddenChannels = {
            enabled = true;
            showMode = 0;
            hideUnreads = true;
          };
          WebKeybinds = {
            enabled = true;
          };
          WebScreenShareFixes = {
            enabled = true;
          };
          WhoReacted = {
            enabled = true;
          };
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          WebContextMenus = {
            enabled = true;
            addBack = true;
          };
          Settings = {
            enabled = true;
            settingsLocation = "aboveNitro";
          };
          DynamicImageModalAPI = {
            enabled = true;
          };
          SupportHelper = {
            enabled = true;
          };
          Experiments = {
            enabled = true;
          };
          BadgeAPI = {
            enabled = true;
          };
        };
        notifications = {
          timeout = 5000;
          position = "bottom-right";
          useNative = "not-focused";
          logLimit = 50;
        };
        cloud = {
          authenticated = false;
          url = "https://api.vencord.dev/";
          settingsSync = false;
          settingsSyncVersion = 1743698969732;
        };
      };

    };
  };
}
