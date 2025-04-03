{
  config,
  pkgs,
  pkgs-stable,
  ...
}:
let
  # Custom latex package
  tex = pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-full
      latexmk
      titlesec
      ;
  };
in
{
  home.packages = with pkgs; [
    # lsps
    lua-language-server
    pyright
    # texlab
    nixd
    llvmPackages_19.clang-unwrapped
    stylua
    typescript-language-server
    nodePackages.bash-language-server
    hyprls

    # typst
    typst
    tinymist
    typstyle

    # Markdown
    pandoc
    live-server

    #formatter
    nixfmt-rfc-style

    # latex
    # tex

    # Utility
    wl-clipboard
  ];
  stylix.targets.neovim.enable = false;
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
}
