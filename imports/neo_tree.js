// /imports/neo_tree.js

const neoTreeConfig = `
require("neo-tree").setup({
  renderer = {
    icons = {
      webdev_colors = true,
      git_placement = "before",
      padding = " ",
      symlink_arrow = " ➛ ",
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
    special_files = {
      ["package.json"] = 1,
      ["webpack.config.js"] = 1,
      ["tsconfig.json"] = 1,
      ["jest.config.js"] = 1,
      ["babel.config.js"] = 1,
      ["eslint.config.js"] = 1,
      ["prettierrc.js"] = 1,
      ["*.js"] = 1,
      ["*.svg"] = 1,
    },
  },
})
`;

module.exports = neoTreeConfig;
