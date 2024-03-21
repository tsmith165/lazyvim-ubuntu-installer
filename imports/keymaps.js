const copiedTextString = `
  local copied_text = "// " .. file_path .. "\\n\`\`\`\\n" .. file_contents .. "\\n\\n"
`;

const keymaps = `
-- Copy and paste using xsel
vim.keymap.set("n", "+y", '"+y')
vim.keymap.set("n", "+p", '"+p')

-- Copy file contents and path to system clipboard
vim.keymap.set("n", "<leader>cf", function()
  local file_path = vim.fn.expand("%:p")
  local file_contents = table.concat(vim.fn.readfile(file_path), "\\n")
  ${copiedTextString}
  vim.fn.setreg("+", copied_text)
  vim.notify("Copied file contents and path to system clipboard")
end)
`;

module.exports = keymaps;
