{
  config,
  pkgs,
  pkgs-stable,
  inputs,
  ...
}: let
  # Custom latex package
  tex = pkgs.texlive.combine {
    inherit
      (pkgs.texlive)
      scheme-small
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
    hyprls

    #formatter
    alejandra

    # latex
    tex

    # Utility
    wl-clipboard
    xclip
  ];
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
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
      {
        plugin = nvim-treesitter.withPlugins (p: [
          p.bash
          p.c
          p.cpp
          p.html
          p.git_config
          p.git_rebase
          p.gitattributes
          p.gitcommit
          p.gitignore
          p.lua
          p.luadoc
          p.markdown
          p.markdown_inline
          p.nix
          p.python
          p.json
          p.vim
          p.vimdoc
          p.latex
        ]);
        # config = ; # TODO:;
        type = "lua";
      }
    ];
    #
    #   extraLuaConfig = ''
    #     ${builtins.readFile ./lua/options.lua}
    #     ${builtins.readFile ./lua/keymaps.lua}
    #   '';
  };
}
