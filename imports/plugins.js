// /imports/plugins.js

const plugins = [
    {
        name: 'CoC',
        config: `
      {
        "neoclide/coc.nvim",
        branch = "release",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "neovim/nvim-lspconfig",
        },
        config = function()
          vim.g.coc_global_extensions = {
            "coc-tsserver",
            "coc-pyright",
            "coc-json",
            "coc-yaml",
            "coc-tailwindcss",
            "coc-markdown-preview-enhanced",
            "coc-sh",
          }
        end,
      },
    `,
    },
    {
        name: 'Tagbar',
        config: `
      {
        "preservim/tagbar",
        opts = {},
      },
    `,
    },
    {
        name: 'Surround',
        config: `
      {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
      },
    `,
    },
    {
        name: 'Plenary',
        config: `
      {
        "nvim-lua/plenary.nvim",
      },
    `,
    },
];

module.exports = plugins;
