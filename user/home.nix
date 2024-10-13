{
  config,
  pkgs,
  lib,
  pkgs-stable,
  inputs,
  userSettings,
  ...
}: let
  userTerminalPath = lib.path.append ./Terminal userSettings.terminal;
  WmConfig = lib.path.append ./wm userSettings.wm;
in {
  imports = [
    ./shell/shell.nix
    ./git

    userTerminalPath
    # ./Terminal/wezterm.nix

    # Window managers
    # This includes either ./wm/hyprland or ./wm/gnome
    WmConfig
    # (./. + ("/wm/" + userSettings.wm))
    # ./wm/ags/ags.nix

    ./editor/nvim.nix
    ./Gaming
    ./filemanager/yazi.nix
    ./browser/firefox.nix

    inputs.impermanence.nixosModules.home-manager.impermanence
    # inputs.xremap-flake.homeManagerModules.default
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
      kdePackages.okular
      lutris
      mpv
      obs-studio
      gimp
      vesktop
      brave

      # calibre
      tor
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
    ])
    ++ (with pkgs-stable; [
      ]);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # ".config/nvim".source = ./user/editor/nvim;
    ".config/ArmCord/storage/settings.json".source = ./Armcord/storage/settings.json;

    # Data symlinks
    "Scripts".source = ./Scripts;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    "Downloads".source = config.lib.file.mkOutOfStoreSymlink /data/Downloads;
    "Dokumente".source = config.lib.file.mkOutOfStoreSymlink /data/Dokumente;
    "Videos".source = config.lib.file.mkOutOfStoreSymlink /data/Videos;
    "Musik".source = config.lib.file.mkOutOfStoreSymlink /data/Musik;
    "Bilder".source = config.lib.file.mkOutOfStoreSymlink /data/Bilder;
    "Software".source = config.lib.file.mkOutOfStoreSymlink /data/Software;
  };
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/me/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    FOO = "Bar";
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

  #configure xremap
  # Get Window name using `hyprctl clients` in Hyprland
  # And `busctl --user call org.gnome.Shell /com/k0kubun/Xremap com.k0kubun.Xremap WMClasses` in gnome
  # Gnome doesnt work see this https://github.com/xremap/xremap/issues/378
  # services.xremap = {
  # withGnome = true;
  #  withWlroots = true;
  #  yamlConfig = ''
  #    modmap:
  #      - name: main;
  #        remap:
  #          CapsLock: esc
  #        application:
  #          not: [kitty, org.gnome.console]
  #
  #        - name: terminal;
  #          remap:
  #            CapsLock:
  #              held: CONTROL_L
  #              alone: esc
  #              alone_timeout_millis: 150
  #          application:
  #            only: [kitty, org.gnome.console, firefox]
  #    '';
  #
  #  };
  services.ssh-agent.enable = true;
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.wofi.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
