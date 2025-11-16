{
  pkgs,
  ...
}:
let
  # Shell aliases
  myShellAliases = {
    test = "cd ..";
    cat = "bat";
    ls = "eza";
    ll = "eza -l";
    lt = "eza -T";
  };
in
{
  services.ssh-agent.enable = true;
  # CLI Tools
  home.packages = with pkgs; [
    bat
    croc
    onefetch
    fastfetch
    tree
    ripgrep
    pandoc
    hwinfo
    zoxide
    btop
    # For autocompletes
    carapace
  ];
  # Shells
  programs.bash = {
    enable = false;
    shellAliases = myShellAliases;
  };
  programs.zsh = {
    enable = true;

    autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = myShellAliases;
  };
  programs.nushell = {
    enable = true;
    configFile.text = ''
      source ~/.cache/carapace/init.nu
    '';
    envFile.text = ''
      # Tab completions
      $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
      mkdir ~/.cache/carapace
      carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

      # Shell vi mode
      $env.config.edit_mode = 'vi'
    '';
  };

  # Shell programms
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    # enableNushellIntegration = true;
  };

  # configure direnv
  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[](bold red)";
      };
      nix_shell = {
        format = ''via [$symbol$state]($style)'';
      };
      directory.substitutions = {
        "~/Dokumente" = "󰈙 ";
        "~/Downloads" = " ";
        "~/.config/nvim" = "";
        "~/Musik" = " ";
        "~/Software" = "";
        "~/Games" = "󰊗";
        "~/Bilder" = " ";
      };
      #[custom.unreal]
      #symbol = "󰦱"  # symbol for this
      #files = ["*.uproject"]       # can specify filters
    };
  };
}
