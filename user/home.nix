{ config, pkgs, pkgs-unstable, inputs, userSettings, ... }:
{
  imports = [
    ./shell/shell.nix
    (./.  + ("/Terminal/" + userSettings.terminal + ".nix" ))
    ./wm/hyprland/default.nix
    inputs.xremap-flake.homeManagerModules.default
  ];
  home.username = "me";
  home.homeDirectory = "/home/me";

  home.stateVersion = "23.11"; # Dont change without reading release change, might break

  nixpkgs.config.allowUnfree = true;

  home.packages = (with pkgs; [
    brave
    obsidian
    calibre
    tor
    zathura
    zotero
    vscode
    prismlauncher
    yt-dlp
    lutris
    pavucontrol
    signal-desktop
    piper
    swaynotificationcenter
    keepassxc
    syncthing
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ]) ++
  (with pkgs-unstable;[
      armcord
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
    "Dokumente".source = config.lib.file.mkOutOfStoreSymlink /data/Dokumente;
    "Bilder".source = config.lib.file.mkOutOfStoreSymlink /data/Bilder;
    "Musik".source = config.lib.file.mkOutOfStoreSymlink /data/Musik;
    "Videos".source = config.lib.file.mkOutOfStoreSymlink /data/Videos;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
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


  # configure git
  programs.git = {
    enable = true;
    userName = "LazyStability";
    userEmail = "Klysmus@online.de";
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = [ 
      "/etc/nixos"
      "/etc/nixos/user/editor/nvim"
      ];
      lsf.enable = true;
    };
  };
  
  #configure xremap
  # Get Window name using `hyprctl clients` in Hyprland
  # And `busctl --user call org.gnome.Shell /com/k0kubun/Xremap com.k0kubun.Xremap WMClasses` in gnome
  # Gnome doesnt work see this https://github.com/xremap/xremap/issues/378
  services.xremap = {
    # withGnome = true;
    withWlroots = true;
    yamlConfig = ''
      modmap:
        - name: main;
          remap:
            CapsLock: esc
          application:
            not: [kitty, org.gnome.console]

        - name: terminal;
          remap:
            CapsLock:
              held: CONTROL_L
              alone: esc
              alone_timeout_millis: 150
          application:
            only: [kitty, org.gnome.console]
    '';

  };
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.wofi.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
