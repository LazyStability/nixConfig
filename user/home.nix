{
  pkgs,
  extraPackages,
  config,
  lib,
  ...
}:
{
  home.stateVersion = "23.11"; # Dont change without reading release change, might break

  nixpkgs.config.allowUnfree = true;
  # Imports all default.nix in all subfolders.
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

  home.packages = (
    with pkgs;
    [
      obsidian
      localsend
      vscode
      libnotify
      # xdg default
      kdePackages.okular

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
      pyright
      # texlab
      nixd
      nix-init # Create derivations from git urls
      harper
      llvmPackages_19.clang-unwrapped
      stylua
      typescript-language-server
      nodePackages.bash-language-server
      hyprls
      # needed for typst preview
      imagemagick
      ghostscript
      markdown-oxide

      starship
      # typst
      typst
      tinymist
      typstyle

      # Markdown
      pandoc
      live-server

      #formatter
      nixfmt

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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };
  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "kitty";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        browser =
          if config.programs.floorp.enable then
            "floorp.desktop"
          else if config.programs.firefox.enable then
            "firefox.desktop"
          else
            "brave.desktop";
      in
      {
        "text/html" = [ browser ];
        "x-scheme-handler/http" = [ browser ];
        "x-scheme-handler/https" = [ browser ];
        "x-scheme-handler/about" = [ browser ];
        "x-scheme-handler/unknown" = [ browser ];
        "x-scheme-handler/ror2mm" = [ "r2modman.desktop" ];
        "x-scheme-handler/chrome" = [ browser ];
        "application/x-extension-htm" = [ browser ];
        "application/x-extension-html" = [ browser ];
        "application/x-extension-shtml" = [ browser ];
        "application/xhtml+xml" = [ browser ];
        "application/x-extension-xhtml" = [ browser ];
        "application/x-extension-xht" = [ browser ];
        "application/pdf" = [ "sioyek.desktop" ];
        "image/png" = [ "imv.desktop" ];
        "image/gif" = [ "imv.desktop" ];
        "image/jpeg" = [ "imv.desktop" ];
        # "inode/directory" = ["yazi-standalone.desktop"];
      };
  };

  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
