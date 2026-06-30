{ pkgs, ... }:
let
  # Shell aliases
  myShellAliases = {
    cat = "bat";
    ls = "eza";
    ll = "eza -l";
    lt = "eza -T";
  };
in
{

  environment.systemPackages = with pkgs; [
    bat
    croc
    onefetch
    sysz
    microfetch
    tree
    ripgrep
    hwinfo
    zoxide
    eza
    btop
    # For autocompletes
    carapace
  ];
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    fzf.fuzzyCompletion = true;
    bash = {
      enable = false;
      shellAliases = myShellAliases;
    };
    zsh = {
      enable = true;

      # autosuggestion.enable = false;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
      enableCompletion = true;
      shellAliases = myShellAliases;
    };
    # Shell programms
    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      flags = [
        "--cmd cd"
      ];
    };
  };
  # zsh main shell
  environment.shells = with pkgs; [ zsh ];
  environment.pathsToLink = [ "/share/zsh" ];
  users.defaultUserShell = pkgs.zsh;
}
