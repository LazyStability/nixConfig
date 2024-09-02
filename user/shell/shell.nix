{ config, pkgs, ... }:
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
  ];
  # Shells
  programs.bash = {
    enable = false;
    shellAliases = myShellAliases;
  };
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = myShellAliases;
  };

  # Shell programms
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  # configure direnv
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[](bold red)";

        # git branch 
        # sudo enable = true
        #[custom.unreal]
        #symbol = "󰦱"  # symbol for this
        #files = ["*.uproject"]       # can specify filters
  };
    };
  };

}
