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
      # {
      #   plugin = nvim-treesitter.withAllGrammars;
      #   # config = ; # TODO:;
      # }
    ];
    #
    #   extraLuaConfig = ''
    #     ${builtins.readFile ./lua/options.lua}
    #     ${builtins.readFile ./lua/keymaps.lua}
    #   '';
  };
  # Treesitter is linked into the expected directory so Lazy.nvim can pick it up
  home.file."./.local/share/nvim/nix-plugins/nvim-treesitter/" = {
    recursive = true;
    source = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
  };
  home.file."~/.config/nvim/lua/nix-treesitter.lua".text = let
    grammarsPath = pkgs.symlinkJoin {
      name = "nvim-treesitter-grammars";
      paths = pkgs.vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
    };
  in ''
      -- also make sure to append treesitter since it bundles some languages
    vim.opt.runtimepath:append("${pkgs.vimPlugins.nvim-treesitter}")
    -- append all *.so files
    vim.opt.runtimepath:append("${grammarsPath}")
  '';
}
