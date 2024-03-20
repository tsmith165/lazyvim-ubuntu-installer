const pluginConfigs = [
    {
        name: 'Python LSP (pyright)',
        config: `
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require("null-ls").setup()
      end,
    },
    opts = {
      servers = {
        pyright = {},
      },
    },
  },
`,
    },
    {
        name: 'TypeScript LSP (tsserver)',
        config: `
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require("null-ls").setup()
      end,
    },
    opts = {
      servers = {
        tsserver = {},
      },
    },
  },
`,
    },
];

module.exports = pluginConfigs;
