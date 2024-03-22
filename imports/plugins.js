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
        config = function()
          vim.g.tagbar_width = 30
          vim.g.tagbar_autoclose = 1
          vim.g.tagbar_autofocus = 1
          vim.g.tagbar_sort = 0
          vim.g.tagbar_compact = 1
          vim.g.tagbar_indent = 1
          vim.g.tagbar_show_linenumbers = 2
          vim.g.tagbar_show_visibility = 1
          vim.g.tagbar_previewwin_pos = "rightbelow"
          vim.g.tagbar_autopreview = 1
          vim.g.tagbar_singleclick = 1
          vim.g.tagbar_foldlevel = 2
        end,
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
    {
        name: 'OneDark',
        config: `
        {
          "navarasu/onedark.nvim",
          config = function()
            require("onedark").setup({
              style = "dark", -- Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
              transparent = false, -- Show/hide background
              term_colors = true, -- Change terminal color as per the selected theme style
              ending_tildes = false, -- Show the end-of-buffer tildes
              cmp_itemkind_reverse = false, -- Reverse item kind highlights in cmp menu
              code_style = {
                comments = "italic",
                keywords = "none",
                functions = "none",
                strings = "none",
                variables = "none",
              },
            })
            vim.cmd("colorscheme onedark")
          end,
        },
      `,
    },
];

module.exports = plugins;
