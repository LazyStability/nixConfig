{config, pkgs, pkgs-stable, ...}:
let 
  # Custom latex package
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-small
      latexmk titlesec;
  });
  in
{
  home.packages = (with pkgs; [
      # lsps
      lua-language-server
      pyright
      texlab
      nil
      llvmPackages_19.clang-unwrapped
      stylua

      # latex
      tex

      # Utility
      wl-clipboard
      xclip
  ]);
  # programs.neovim = {
  #   enable = true;
  #
  #   viAlias = true;
  #   vimAlias = true;
  #   vimdiffAlias = true;
  #
  #   plugins = with pkgs.vimPlugins; [
  #
  #     #########
  #     ## lsp ##
  #     #########
  #     {
  #       plugin = nvim-lspconfig;
  #       # config = ./lua/plugins/lspconfig.lua;
  #       # type = "lua";
  #     }
  #
  #     ############
  #     ## linter ##
  #     ############
  #     {
  #       plugin = nvim-lint;
  #       # config = ./lua/plugins/lint.lua;
  #       # type = "lua";
  #     }
  #
  #     ###############
  #     ## formattor ##
  #     ###############
  #     {
  #       plugin = conform-nvim;
  #       # config = ./lua/plugins/conform.lua;
  #       # type = "lua";
  #     }
  #
  #     ###########
  #     ## Latex ##
  #     ###########
  #     {
  #       plugin = vimtex;
  #       # config = ./lua/plugins/vimtex.lua;
  #       # type = "lua";
  #     }
  #
  #     ####################
  #     ## Autocompletion ##
  #     ####################
  #     luasnip
  #     cmp_luasnip
  #     cmp-nvim-lsp
  #     cmp-path
  #     #friendly-snippets
  #     {
  #       plugin = nvim-cmp;
  #       # config = ./lua/plugins/cmp.lua;
  #       # type = "lua";
  #     }
  #     {
  #       plugin = nvim-autopairs;
  #       # config = ;
  #       # type = "lua";
  #     }
  #
  #     ##################
  #     ## Fuzzy Finder ##
  #     ##################
  #     nvim-web-devicons
  #     # plenary-nvim
  #     telescope-ui-select-nvim
  #     telescope-fzf-native-nvim
  #     {
  #       plugin = telescope-nvim;
  #       # config = ./lua/plugins/telescope-fzf.lua;
  #       # type = "lua";
  #     }
  #     
  #
  #     {
  #       plugin = which-key-nvim;
  #       # config = ./lua/plugins/which-key.lua;
  #       # type = "lua";
  #
  #     }
  #     #########
  #     ## Git ##
  #     #########
  #     # telescope-nvim
  #     plenary-nvim
  #     diffview-nvim
  #     {
  #       plugin = neogit;
  #       # config = ./lua/plugins/neogit.lua;
  #       # type = "lua";
  #     }
  #     {
  #       plugin = gitsigns-nvim;
  #       # config = ;
  #       # type = "lua";
  #     }
  #     #############
  #     ## lualine ##
  #     #############
  #     {
  #       plugin = lualine-nvim;
  #       # config = ./lua/plugins/lualine.lua;
  #       # type = "lua";
  #     }
  #
  #     ###########
  #     ## Theme ##
  #     ###########
  #     {
  #       plugin = tokyonight-nvim;
  #       # config = ./lua/plugins/tokyonight.lua;
  #       # type = "lua";
  #     }
  #
  #     ###################
  #     ## Miscellenious ##
  #     ###################
  #     vim-be-good
  #     indent-blankline-nvim
  #     todo-comments-nvim
  #     vim-sleuth
  #     neodev-nvim
  #     comment-nvim
  #     {
  #       plugin = undotree;
  #       config = ''
  #         vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, {desc = 'Show the [U]ndotree'})
  #       '';
  #       type = "lua";
  #     }
  #
  #
  #     {
  #       plugin = (nvim-treesitter.withPlugins (p: [
  #         p.tree-sitter-bash
  #         p.tree-sitter-c
  #         p.tree-sitter-cpp
  #         p.tree-sitter-html
  #         p.tree-sitter-git_config
  #         p.tree-sitter-git_rebase
  #         p.tree-sitter-gitattributes
  #         p.tree-sitter-gitcommit
  #         p.tree-sitter-gitignore
  #         p.tree-sitter-lua
  #         p.tree-sitter-luadoc
  #         p.tree-sitter-markdown
  #         p.tree-sitter-markdown_inline
  #         p.tree-sitter-nix
  #         p.tree-sitter-python
  #         p.tree-sitter-json
  #         p.tree-sitter-vim
  #         p.tree-sitter-vimdoc
  #       ]));
  #       # config = ; # TODO:;
  #       type = "lua";
  #     }
  #   ];
  #
  #   extraLuaConfig = '' 
  #     ${builtins.readFile ./lua/options.lua}
  #     ${builtins.readFile ./lua/keymaps.lua}
  #   '';
  # };
}
