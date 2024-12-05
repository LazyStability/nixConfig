{
  config,
  pkgs,
  pkgs-stable,
  ...
}: let
  # Custom latex package
  tex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-full
      latexmk
      titlesec
      ;
  };
in {
  home.packages = with pkgs; [
    # lsps
    lua-language-server
    pyright
    texlab
    nixd
    llvmPackages_19.clang-unwrapped
    stylua
    typescript-language-server
    nodePackages.bash-language-server
    hyprls

    #formatter
    alejandra

    # latex
    tex

    # Utility
    wl-clipboard
    xclip
  ];
  stylix.targets.neovim.enable = false;
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-treesitter-context
      nvim-web-devicons
      render-markdown-nvim
    ];
  };
  # Treesitter is linked into the expected directory so Lazy.nvim can pick it up
  # home.file."./.local/share/nvim/nix-plugins/nvim-treesitter/" = {
  #   recursive = true;
  #   source = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
  # };
  # home.file."~/.config/nvim/lua/nix-treesitter.lua".text = let
  #   grammarsPath = pkgs.symlinkJoin {
  #     name = "nvim-treesitter-grammars";
  #     paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
  #   };
  # in ''
  #     -- also make sure to append treesitter since it bundles some languages
  #   vim.opt.runtimepath:append("${pkgs.vimPlugins.nvim-treesitter}")
  #   -- append all *.so files
  #   vim.opt.runtimepath:append("${grammarsPath}")
  # '';
}
