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

}
