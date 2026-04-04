{
  lib,
  inputs,
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
        (lib.lists.flatten (recurse "" set));
    in
    (flatten (go ./.));

  hjem.users.me = {
    user = "me";
    directory = "/home/me";
    clobberFiles = false;

    packages = (
      with pkgs;
      [
        obsidian
        localsend
        vscode
        libnotify
        # xdg default
        kdePackages.okular

        # Desktop
        hypridle
        hyprlock
        hyprsunset
        hyprpolkitagent
        hyprshot
        waybar
        fuzzel
        pwvucontrol
        swaynotificationcenter
        bibata-cursors

        imv
        keymapp
        piper
        networkmanagerapplet
        networkmanager-openvpn
        # blueberry
        element-desktop
        # iamb

        # Musik
        rmpc
        mpd
        mpd-mpris

        gimp
        brave
        nautilus

        # lsps
        lua-language-server
        # texlab
        nixd
        harper
        llvmPackages_19.clang-unwrapped
        stylua
        typescript-language-server
        nodePackages.bash-language-server
        hyprls
        # needed for typst preview
        imagemagick
        ghostscript
        nixfmt
        markdown-oxide

        starship
        # typst
        typst
        tinymist
        typstyle

        # Markdown
        pandoc
        live-server

        # latex
        # tex

        # Utility
        wl-clipboard

        # calibre
        (inkscape-with-extensions.override {
          inkscapeExtensions = [ inkscape-extensions.textext ];
        })
        hyperfine
        tor-browser
        newsboat
        nushell
        reddit-tui
        anki
        zotero
        prismlauncher
        yt-dlp
        wl-clipboard
        signal-desktop
        piper
        remmina
        w3m
        komikku
        kitty
        # patched-keepassxc
        keepassxc
      ]
      ++ (with extraPackages; [
        vesktop
        wiki-tui
        sioyek
        mpv
        rnote
        kitty-sessionizer
        dungeondraft
        yazi
      ])
    );

    # Firefox
    files =
      let
        recurseIntoDir =
          target_path: source_dir:
          builtins.listToAttrs (
            map (
              x:
              let
                target = target_path + (lib.removePrefix (toString source_dir) (toString x));
              in
              {
                name = target;
                value = {
                  type = "copy";
                  source = x;
                  inherit target;
                };
              }
            ) (lib.filesystem.listFilesRecursive source_dir)
          );
      in
      {
        # Firefox
        ".mozilla/firefox/me/chrome/natsumi".source = inputs.natsumi-theme + "/natsumi";
        ".mozilla/firefox/me/chrome/natsumi-config.css".source =
          inputs.natsumi-theme + "/natsumi-config.css";
        ".mozilla/firefox/me/user.js".text =
          (builtins.readFile "${pkgs.arkenfox-userjs}/user.js")
          + (builtins.readFile ./env/mozilla/firefox/me/user-overrides.js);

        ".zshrc".source = ./env/zshrc;
        ".zshenv".source = ./env/zshenv;
      }
      // (recurseIntoDir ".mozilla" ./env/mozilla)
      // (recurseIntoDir ".ssh" ./env/ssh);
  };

}
