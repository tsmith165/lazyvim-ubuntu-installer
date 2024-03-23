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
        git = true
      },
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "",
        file = {
          default = "*",
        },
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = ""
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌"
        }
      }
    }
  },
  special_files = {
    ["package.json"] = 1,
    ["vercel.json"] = 1,
    ["schema.prisma"] = 1,
    ["tsconfig.json"] = 1,
    ["yarn.lock"] = 1,
    ["jsonconfig.json"] = 1,
    ["Cargo.toml"] = 1,
    ["README.md"] = 1,
    ["Makefile"] = 1,
    ["COPYING"] = 1,
    ["LICENSE"] = 1,
    ["Dockerfile"] = 1,
    ["docker-compose.yml"] = 1,
    ["*.js"] = 1,
    ["*.ts"] = 1,
    ["*.svg"] = 1
  },
  filtered_items = {
    visible = false, -- when true, hide files/folders that match the glob patterns
    hide_dotfiles = false,
    hide_gitignored = false,
    hide_hidden = false, -- only works on Windows for hidden files/folders
    hide_by_name = {
      ".DS_Store",
      "thumbs.db",
      "node_modules"
    },
    hide_by_pattern = {
      "*.meta"
    },
    never_show = {
      ".DS_Store",
      "thumbs.db"
    }
  }
});
`;

module.exports = neoTreeConfig;
