{config, pkgs, ...}:
{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      comment-nvim

      nvim-cmp
      telescope-nvim
      telescope-fzf-native-nvim
      cmp_luasnip
      cmp-nvim-lsp
      luasnip
    ];

    extraLuaConfig = '' 
      ${builtins.readFile /dotfiles/nvim/lua/options.lua}
      ${builtins.readFile /dotfiles/nvim/lua/keymaps.lua}
      ${builtins.readFile /dotfiles/nvim/lua/autocommands.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/health.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/cmp.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/lint.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/mini.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/conform.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/gitsigns.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/autopairs.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/lspconfig.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/which-key.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/tokyonight.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/treesitter.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/indent_line.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/telescope-fzf.lua}
      ${builtins.readFile /dotfiles/nvim/lua/kickstart/plugins/todo-comments.lua}
      ${builtins.readFile /dotfiles/nvim/lua/custom/plugins/neogit.lua}
      ${builtins.readFile /dotfiles/nvim/lua/custom/plugins/vimtex.lua}
      ${builtins.readFile /dotfiles/nvim/lua/custom/plugins/undotree.lua}
      ${builtins.readFile /dotfiles/nvim/lua/custom/plugins/vimbegood.lua}
    '';
  };
}
