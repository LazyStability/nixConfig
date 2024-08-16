{ config, pkgs, inputs, ... }:
{
  imports = [
    ./user/shell/shell.nix
    ./user/Terminal/kitty.nix
    ./user/wm/hyprland/default.nix
    inputs.xremap-flake.homeManagerModules.default
  ];
  home.username = "me";
  home.homeDirectory = "/home/me";

  home.stateVersion = "23.11"; # Dont change without reading release change, might break

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
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
    armcord
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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".config/nvim".source = ./user/editor/nvim;
    ".config/ArmCord/storage/settings.json".source = ./user/Armcord/storage/settings.json;
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

  # configure tmux
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    prefix = "C-s";
    keyMode = "vi";
    extraConfig = "set-option -g status-position top";


    # Smart pane switching with awareness of Vim splits.
    # See: https://github.com/christoomey/vim-tmux-navigator
    # is_vim = "ps -o state= -o comm= -t '#{pane_tty}' \
    # | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
    #  bind-key - n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane - L'
    #  bind-key - n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane - D'
    #  bind-key - n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane - U'
    #  bind-key - n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane - R'
    #  tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
    # if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    # "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
    # if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    # "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

    # bind-key -T copy-mode-vi 'C-h' select-pane -L
    # bind-key -T copy-mode-vi 'C-j' select-pane -D
    # bind-key -T copy-mode-vi 'C-k' select-pane -U
    # bind-key -T copy-mode-vi 'C-l' select-pane -R
    # bind-key -T copy-mode-vi 'C-\' select-pane -l

  };

  # configure git
  programs.git = {
    enable = true;
    userName = "LazyStabilty";
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
    withHypr = true;
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

  # configure direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
