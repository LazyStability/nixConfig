{config, pkgs, pkgs-unstable, ...}:
let 
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-small
      latexmk titlesec;
  });
  in
{
  home.packages = (with pkgs-unstable; [
      lua-language-server
      pyright
      texlab
      nil
      llvmPackages_19.clang-unwrapped
      stylua
      tex
  ]);
  # programs.neovim = {
  #   enable = true;
  #
  #   viAlias = true;
  #   vimAlias = true;
  #   vimdiffAlias = true;
  #   extraPackages = with pkgs-unstable; [
  #   ];

  #   plugins = with pkgs.vimPlugins; [
  #
  #     {
  #       plugin = nvim-lspconfig;
  #       config = toLuaFile ./nvim/plugin/lsp.lua;
  #     }
  #
  #     {
  #       plugin = comment-nvim;
  #       config = toLua "require(\"Comment\").setup()";
  #     }
  #
  #     {
  #       plugin = gruvbox-nvim;
  #       config = "colorscheme gruvbox";
  #     }
  #
  #     neodev-nvim
  #
  #     nvim-cmp 
  #     {
  #       plugin = nvim-cmp;
  #       config = toLuaFile ./nvim/plugin/cmp.lua;
  #     }
  #
  #     {
  #       plugin = telescope-nvim;
  #       config = toLuaFile ./nvim/plugin/telescope.lua;
  #     }
  #
  #     telescope-fzf-native-nvim
  #
  #     cmp_luasnip
  #     cmp-nvim-lsp
  #
  #     luasnip
  #     friendly-snippets
  #
  #
  #     lualine-nvim
  #     nvim-web-devicons
  #
  #     {
  #       plugin = (nvim-treesitter.withPlugins (p: [
  #         p.tree-sitter-nix
  #         p.tree-sitter-vim
  #         p.tree-sitter-bash
  #         p.tree-sitter-lua
  #         p.tree-sitter-python
  #         p.tree-sitter-json
  #       ]));
  #       config = toLuaFile ./nvim/plugin/treesitter.lua;
  #     }
  #   ];
  #
  #   extraLuaConfig = '' 
  #   '';
  # };
}
