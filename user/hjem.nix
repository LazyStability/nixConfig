{
  lib,
  pkgs,
  extraPackages,
  ...
}:
{

  imports =
    let
      go =
        dir:
        builtins.mapAttrs (
          n: v:
          if v == "regular" && n == "default.nix" then
            dir + "/${n}"
          else if v == "directory" then
            go (dir + "/${n}")
          else
            { }
        ) (builtins.readDir dir);
      flatten =
        set:
        let
          recurse =
            path:
            lib.attrsets.mapAttrsToList (
              name: value: if builtins.isAttrs value then recurse (path ++ name) value else value
            );
        in
        lib.lists.flatten (recurse "" set);
    in
    flatten (go ./.);

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
        wl-clipboard
        signal-desktop
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
        calibre
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
        vesktop
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
