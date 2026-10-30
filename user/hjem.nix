{
  lib,
  pkgs,
  extraPackages,
  jail,
  ...
}:
let
  gui-app = (
    appName: appID: with jail.combinators; [
      gui

      # Usually the one unsandboxed path
      (readwrite (noescape "\"$HOME/Downloads\""))

      # Directly bind XDG_BASE_DIRS into the sandbox
      (readwrite (noescape "\"$XDG_CONFIG_HOME/${appName}\""))
      (readwrite (noescape "\"$XDG_CACHE_HOME/${appName}\""))
      (readwrite (noescape "\"$XDG_DATA_HOME/${appName}\""))
      (readwrite (noescape "\"$XDG_STATE_HOME/${appName}\""))
      (add-runtime ''
        mkdir -p "$XDG_STATE_HOME/${appName}" "$XDG_DATA_HOME/${appName}" "$XDG_CONFIG_HOME/${appName}" "$XDG_CACHE_HOME/${appName}" "$XDG_RUNTIME_DIR/app/${appID}"
      '')

      # Bind all the gtk/qt configs into the sandbox
      (readonly (noescape "\"$HOME/.themes/\""))
      (readonly (noescape "\"$HOME/.local/share/icons\""))
      (readonly (noescape "\"$HOME/.gtkrc-2.0\""))
      (readonly (noescape "\"$HOME/.config/gtk-3.0\""))
      (readonly (noescape "\"$HOME/.config/Kvantum\""))
      (readonly (noescape "\"$HOME/.config/qt5ct\""))
      (readonly (noescape "\"$HOME/.config/qt6ct\""))
      (readonly (noescape "\"$HOME/.Xresources\""))
      (set-env "GTK2_RC_FILES" "/home/me/.gtkrc-2.0")
      (set-env "QT_QPA_PLATFORMTHEME" "qt5ct")
      (set-env "QT_STYLE_OVERRIDE" "kvantum")

      (dbus {
        own = [
          "${appID}"
        ];
        talk = [
          "org.kde.StatusNotifierWatcher" # Tray functionalities on KDE
          "com.canonical.AppMenu.Registrar"
          "org.freedesktop.portal.*"
          "org.freedesktop.FileChooser"
          "org.freedesktop.portal.Documents"
          "org.freedesktop.portal.Flatpak"
          "org.freedesktop.portal.Desktop"
          "org.freedesktop.portal.FileChooser"
        ];
        call = [
        ];
        broadcast = [
        ];

        flatpakId = "${appID}";
      })
    ]
  );
  jailed-vesktop = jail "vesktop" extraPackages.vesktop (
    with jail.combinators;
    [
      gpu
      network
      (try-readwrite (noescape "\"$XDG_DATA_HOME/steam-sandbox/.steam\""))
      (try-readwrite (noescape "\"$XDG_RUNTIME_DIR/speech-dispatcher\""))
    ]
    ++ gui-app "vesktop" "dev.vencord.Vesktop"
  );
  jailed-signal-desktop = jail "signal-desktop" pkgs.signal-desktop (
    with jail.combinators;
    [
      gpu
      network
      pulse
    ]
    ++ gui-app "Signal" "org.signal.Signal"
  );

in
{

  imports = [
    ./env
    ./scripts
    ./systemd
  ];

  # TODO: Keep until Zotero 11 lands
  # See: https://github.com/NixOS/nixpkgs/pull/572466
  nixpkgs.config.permittedInsecurePackages = [
    "firefox-esr-140-bin-unwrapped-140.17.0esr"
  ];

  hjem.users.me = {
    environment.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      TERMINAL = "kitty";
      XCURSOR_SIZE = 24;
      XCURSOR_THEME = "Bibata-Modern-Ice";
      HYPRCURSOR_THEME = "Bibata-Modern-Ice";
      HYPRCURSOR_SIZE = 24;
      QT_QPA_PLATFORMTHEME = "qt6ct"; # or qt6ct
      QT_STYLE_OVERRIDE = "kvantum";
      GTK2_RC_FILES = "/home/me/.gtkrc-2.0";
      QT_PLUGIN_PATH = "${pkgs.libsForQt5.qtstyleplugin-kvantum}/lib:${pkgs.qt6Packages.qtstyleplugin-kvantum}/lib";
      XDG_DESKTOP_DIR = "$HOME/Desktop";
      MPD_HOST = "$XDG_RUNTIME_DIR/mpd/socket";
      XDG_DOCUMENTS_DIR = "$HOME/Dokumente";
      XDG_DOWNLOAD_DIR = "$HOME/Downloads";
      XDG_MUSIC_DIR = "$HOME/Musik";
      XDG_PICTURES_DIR = "$HOME/Bilder";
      XDG_PROJECTS_DIR = "$HOME/Software";
      XDG_VIDEOS_DIR = "$HOME/Videos";
    };

    user = "me";
    directory = "/home/me";
    clobberFiles = true;

    packages =
      with pkgs;
      [
        libnotify

        # Desktop
        hypridle
        hyprlock
        hyprsunset
        hyprpolkitagent
        grim
        slurp
        satty
        awww
        waybar
        fuzzel
        pwvucontrol
        networkmanager_dmenu
        swaynotificationcenter
        bibata-cursors
        libsForQt5.qtstyleplugin-kvantum
        qt6Packages.qtstyleplugin-kvantum
        # Alternative to uwsm app
        runapp

        imv
        keymapp
        networkmanagerapplet
        networkmanager-openvpn
        # blueberry
        # iamb

        # Musik
        rmpc
        mpd
        mpd-mpris

        brave
        nautilus

        # lsps
        lua-language-server
        # texlab
        nixd
        harper
        jq
        llvmPackages_19.clang-unwrapped
        stylua
        typescript-language-server
        bash-language-server
        # needed for typst preview and generally useful cli tools
        imagemagick
        ghostscript

        zip
        pdftk

        nixfmt
        markdown-oxide

        starship
        # typst
        typst
        tinymist
        typstyle

        # Markdown

        # latex
        # tex

        # Utility
        wl-clipboard

        hyperfine
        comma
        nix-index
        nix-init
        tor-browser
        newsboat
        nushell
        # reddit-tui
        zotero
        yt-dlp
        jailed-signal-desktop
        kitty
        # age
        # rage
        # passage, now in extraPackages
        # (pass.withExtensions (ext: with ext; [ pass-otp ]))
        age-plugin-yubikey
        # patched-keepassxc

        bubblewrap

        # Gui applications
        # TODO: Sandboxing
        xournalpp
        # calibre
        ausweisapp
        abaddon
        rnote
        gimp
        remmina
        piper
        keepassxc
        # anki
        # xdg default
        kdePackages.okular
        element-desktop
        (inkscape-with-extensions.override {
          inkscapeExtensions = [ inkscape-extensions.textext ];
        })

      ]
      ++ (with extraPackages; [
        jailed-vesktop
        sioyek
        mpv
        rage
        (
          (extraPackages.passage.override {
            passage = extraPackages.passage.override { age = extraPackages.rage; };
          }).withExtensions
          (ext: with ext; [ pass-otp ])
        )
        # rnote
        kitty-sessionizer
        hyprland-preview-share-picker
        # rofi-xdph
        # hyprselect
        # dungeondraft
        yazi
      ]);

  };

}
