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
    fastfetch
    tree
    ripgrep
    hwinfo
    zoxide
    eza
    fzf
    btop
    # For autocompletes
    carapace
  ];
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.bash = {
    enable = false;
    shellAliases = myShellAliases;
  };
  programs.zsh = {
    enable = true;

    # autosuggestion.enable = false;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    shellAliases = myShellAliases;
  };
  # Shell programms
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    flags = [
      "--no-cmd"
      "--cmd j"
    ];
  };
}
