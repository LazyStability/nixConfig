{ config, pkgs, ... }:
let
  # Shell aliases
  myShellAliases = {
    ll = "ls -l";
    test = "cd ..";
    cat = "bat";
  };
in
{
  # CLI Tools
  home.packages = with pkgs; [
    bat
    croc
    fzf
    onefetch
    fastfetch
    tree
    ripgrep
    pandoc
    hwinfo
    zoxide
  ];
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
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };

}
