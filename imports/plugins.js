const plugins = [
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
    {
        name: 'TypeScript Tools',
        config: `
{
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
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
