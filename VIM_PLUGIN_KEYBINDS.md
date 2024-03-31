# Plugin and Custom Keybinds

This document provides an overview of the keybinds specific to plugins and custom configurations in the Neovim setup.

## Custom Bashrc Commands

-   `cdm`: Change directory to `/root/dev/main/`
-   `cds`: Change directory to `/root/dev/scripts/`
-   `cdl`: Change directory to the most recently modified directory
-   `sbrc`: Source `.bashrc` file
-   `nbrc`: Open `.bashrc` file in Neovim

## Custom Vim Keymaps

-   `<leader>cf`: Copy file contents and path to system clipboard

## LazyVim

-   `<leader>e`: Open file tree
-   `<leader>ff`: Find files
-   `<leader>fg`: Live grep (search within files)
-   `<leader>fr`: Find and replace
-   `<leader>ll`: Open LazyVim log
-   `<leader>lc`: Open LazyVim config
-   `<leader>lp`: Open LazyVim plugins
-   `<leader>ls`: Sync LazyVim plugins
-   `<leader>uC`: Change color scheme

## CoC

-   `gd`: Go to definition
-   `gy`: Go to type definition
-   `gi`: Go to implementation
-   `gr`: Go to references
-   `gs`: Go to source
-   `<leader>ca`: Code action
-   `<leader>cf`: Format document
-   `<leader>cr`: Rename symbol

## Surround

-   `ys{motion}{char}`: Add surround
-   `cs{old}{new}`: Change surround
-   `ds{char}`: Delete surround
-   `S{char}`: Surround visual selection

## Tagbar

-   `<leader>t`: Toggle Tagbar

## Harpoon

-   `<leader>ha`: Add file to Harpoon
-   `<leader>hA`: Add file to a specific Harpoon slot
-   `<leader>hs`: Toggle Harpoon quick menu
-   `<leader>ht`: Open Telescope list of Harpoon marks
-   `<leader>hn`: Navigate to the next Harpoon file
-   `<leader>hp`: Navigate to the previous Harpoon file
-   `<leader>h1` to `<leader>h6`: Navigate to Harpoon files in slots 1 to 6
-   `<leader>hc`: Clear a Harpoon mark by index
