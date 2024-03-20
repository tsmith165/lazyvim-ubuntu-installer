const pluginConfigs = [
    {
        name: 'Python LSP (pyright)',
        config: `
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvimtools/none-ls.nvim",
    },
    opts = {
      servers = {
        pyright = {},
      },
      setup = {
        pyright = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            if client.name == "pyright" then
              require("none-ls").setup({})
            end
          end)
          require("lspconfig").pyright.setup(opts)
        end,
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
      "nvimtools/none-ls.nvim",
    },
    opts = {
      servers = {
        tsserver = {},
      },
      setup = {
        tsserver = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            if client.name == "tsserver" then
              require("none-ls").setup({})
            end
          end)
          require("lspconfig").tsserver.setup(opts)
        end,
      },
    },
  },
`,
    },
];

module.exports = pluginConfigs;
