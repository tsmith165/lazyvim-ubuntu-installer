---@type ChadrcConfig
local M = {}

M.ui = { theme = 'oceanic-next' }

M.plugins = 'custom.plugins'

local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return M
end

-- Python LSP setup
lspconfig.pyright.setup{
  on_attach = function(client, bufnr)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
  end,
}

-- JavaScript and TypeScript LSP setup
lspconfig.tsserver.setup{
  on_attach = function(client, bufnr)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
  end,
}

return M