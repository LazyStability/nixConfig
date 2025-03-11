{
  config,
  pkgs,
  lib,
  pkgs-stable,
  inputs,
  userSettings,
  ...
}: let
  userTerminalPath = lib.path.append ../../user/Terminal userSettings.terminal;
  WmConfig = lib.path.append ../../user/wm userSettings.wm;
  monitor = [
    "DP-1, 2560x1440@60, 0x0, 1"
    "Unknown-1,disabled"
  ];
in {
  imports = [
    ../../user/shell
    ../../user/git
    ../../user/ssh

    userTerminalPath

    # Window managers
    # This includes either ./wm/hyprland or ./wm/gnome
    # WmConfig
    (import ../../user/wm/hyprland {
      monitor = monitor;
      inputs = inputs;
      pkgs = pkgs;
      userSettings = userSettings;
      config = config;
    })

    ../../user/editor/nvim.nix
    ../../user/Gaming
    ../../user/filemanager/yazi.nix
    ../../user/browser/firefox/firefox.nix
    ../../user/browser/zen/zen.nix
    ../../user/Messenger
    ../../user/Scripts

    # inputs.impermanence.nixosModules.home-manager.impermanence
  ];
  home.username = "me";
  home.homeDirectory = "/home/me";

  home.stateVersion = "23.11"; # Dont change without reading release change, might break

  nixpkgs.config.allowUnfree = true;

  home.packages =
    (with pkgs; [
      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
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
      pwvucontrol
      wl-clipboard
      signal-desktop
      piper
      swaynotificationcenter
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
