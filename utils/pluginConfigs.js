const pluginConfigs = [
    {
        name: 'Python LSP (pyright)',
        config: `
  {
    "neovim/nvim-lspconfig",
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
