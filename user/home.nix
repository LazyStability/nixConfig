{
  pkgs,
  pkgs-stable,
  ...
}: {
  home.stateVersion = "23.11"; # Dont change without reading release change, might break

  nixpkgs.config.allowUnfree = true;

  home.packages =
    (with pkgs; [
      obsidian
      vscode
      # xdg default
      kdePackages.okular
      imv
      mpv
      glance
      wealthfolio
      keymapp

      obs-studio
      gimp
      brave
      nautilus

      # calibre
      tor
      saber
      zathura
      zotero
      prismlauncher
      yt-dlp
      wl-clipboard
      signal-desktop
      piper
      keepassxc
      remmina
    ])
    ++ (with pkgs-stable; [
      ]);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # home.persistence."/persist/home/me" = {
  #  directories = [
  #    {
  #      directory = ".local/share/Steam";
  #      method = "symlink";
  #    }
  #  ];
  #  allowOther = true; # Allows other users to access these files
  # };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = ["firefox-esr.desktop"];
      "x-scheme-handler/http" = ["firefox-esr.desktop"];
      "x-scheme-handler/https" = ["firefox-esr.desktop"];
      "x-scheme-handler/about" = ["firefox-esr.desktop"];
      "x-scheme-handler/unknown" = ["firefox-esr.desktop"];
      "x-scheme-handler/ror2mm" = ["r2modman.desktop"];
      "x-scheme-handler/chrome" = ["firefox-esr.desktop"];
      "application/x-extension-htm" = ["firefox-esr.desktop"];
      "application/x-extension-html" = ["firefox-esr.desktop"];
      "application/x-extension-shtml" = ["firefox-esr.desktop"];
      "application/xhtml+xml" = ["firefox-esr.desktop"];
      "application/x-extension-xhtml" = ["firefox-esr.desktop"];
      "application/x-extension-xht" = ["firefox-esr.desktop"];
      "application/pdf" = ["org.kde.okular.desktop"];
      "image/png" = ["imv.desktop"];
      "image/gif" = ["imv.desktop"];
      "image/jpeg" = ["imv.desktop"];
      # "inode/directory" = ["yazi-standalone.desktop"];
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
