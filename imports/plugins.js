const ENABLE_COC = true;
const ENABLE_TAGBAR = true;
const ENABLE_WEB_DEVICONS = true;
const ENABLE_ONEDARK = true;
const ENABLE_HARPOON = true;

const plugins = [
    {
        name: 'CoC',
        disabled: !ENABLE_COC,
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
            "coc-prisma",
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
        disabled: !ENABLE_TAGBAR,
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
            vim.g.tagbar_ctags_bin = '/usr/bin/ctags'
    
            vim.keymap.set("n", "<leader>t", ":TagbarToggle<CR>")
          end,
        },
      `,
    },
    {
        name: 'Web DevIcons',
        disabled: !ENABLE_WEB_DEVICONS,
        config: `
        {
          "kyazdani42/nvim-web-devicons",
          config = function()
            require('nvim-web-devicons').setup {
              default = true;
            }
          end,
        },
      `,
    },
    {
        name: 'OneDark',
        disabled: !ENABLE_ONEDARK,
        config: `
        {
          "navarasu/onedark.nvim",
          config = function()
            require("onedark").setup({
              style = "dark",
              transparent = false,
              term_colors = true,
              ending_tildes = false,
              cmp_itemkind_reverse = false,
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
    {
        name: 'Harpoon',
        disabled: !ENABLE_HARPOON,
        config: `
      {
        "ThePrimeagen/harpoon",
        requires = {"nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim"},
        config = function()
          require("harpoon").setup({
            global_settings = {
              save_on_toggle = false,
              save_on_change = true,
              enter_on_sendcmd = false,
              excluded_filetypes = {"harpoon"},
              menu = {
                width = vim.api.nvim_win_get_width(0) - 20,
              },
            },
          })
    
          local mark = require("harpoon.mark")
          local ui = require("harpoon.ui")
    
          vim.keymap.set("n", "<leader>ha", mark.add_file)
          vim.keymap.set("n", "<leader>hA", function()
            local file_path = vim.fn.expand("%:p")
            local index = vim.fn.input('Add file to Harpoon slot: ')
            mark.set_current_at(tonumber(index))
            mark.add_file(file_path)
            ui.toggle_quick_menu()
          end)
          vim.keymap.set("n", "<leader>hs", ui.toggle_quick_menu)
          vim.keymap.set("n", "<leader>ht", function()
            require("telescope").extensions.harpoon.marks()
          end)
          vim.keymap.set("n", "<leader>hn", ui.nav_next)
          vim.keymap.set("n", "<leader>hp", ui.nav_prev)
          vim.keymap.set("n", "<leader>h1", function() ui.nav_file(1) end)
          vim.keymap.set("n", "<leader>h2", function() ui.nav_file(2) end)
          vim.keymap.set("n", "<leader>h3", function() ui.nav_file(3) end)
          vim.keymap.set("n", "<leader>h4", function() ui.nav_file(4) end)
          vim.keymap.set("n", "<leader>h5", function() ui.nav_file(5) end)
          vim.keymap.set("n", "<leader>h6", function() ui.nav_file(6) end)
          vim.keymap.set("n", "<leader>hc", function()
            local index = vim.fn.input('Mark index to clear: ')
            mark.rm_file(tonumber(index))
            ui.toggle_quick_menu()
          end)
        end
      }
      `,
    },
];

module.exports = plugins;
