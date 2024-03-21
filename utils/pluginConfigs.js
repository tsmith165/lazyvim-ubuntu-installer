const pluginConfigs = [
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
    {
        name: 'OSC 52 Yank',
        config: `
{
  "osc52.vim",
  config = function()
    local function osc52_yank()
      local buffer = vim.fn.system("base64", vim.fn.getreg("0"))
      buffer = vim.fn.substitute(buffer, "\\n", "", "")
      buffer = "\\e]52;c;" .. buffer .. "\\e\\"
      vim.fn.system("echo -ne " .. vim.fn.shellescape(buffer) .. " > " .. vim.fn.shellescape(vim.g.tty))
    end

    vim.keymap.set("n", "<Leader>y", osc52_yank, { silent = true })
  end,
},
`,
    },
];

module.exports = pluginConfigs;
