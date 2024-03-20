local plugins = {
    {
      "neovim/nvim-lspconfig",
      config = function()
        require "plugins.configs.lspconfig"
      end,
    },
    {
      "williamboman/mason.nvim",
      config = function()
        require "plugins.configs.mason"
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      config = function()
        require "plugins.configs.mason-lspconfig"
      end,
    },
  }
  
  return plugins