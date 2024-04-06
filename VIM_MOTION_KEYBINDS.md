# Generic Vim/Tmux Motion Keybinds

This document provides an overview of the generic keybinds for Vim and Tmux.

## Vim

### Navigation

-   `h`, `j`, `k`, `l`: Move cursor left, down, up, right
-   `w`: Move to the start of the next word
-   `b`: Move to the start of the previous word
-   `e`: Move to the end of the current word
-   `0`: Move to the start of the line
-   `^`: Move to the first non-blank character of the line
-   `$`: Move to the end of the line
-   `gg`: Go to the first line of the file
-   `G`: Go to the last line of the file
-   `:{line_number}`: Go to a specific line number
-   `Ctrl+u`: Page up
-   `Ctrl+d`: Page down

### Selection

-   `ggVG`: Select the entire file
-   `V`: Select the current line
-   `viw`: Select the current word
-   `vi"`: Select inside double quotes

### Copying and Pasting

-   `y`: Yank (copy) the selected text
-   `yy`: Yank (copy) the current line
-   `p`: Paste after the cursor
-   `P`: Paste before the cursor
-   `"+y`: Copy the selected text to the system clipboard
-   `"+p`: Paste text from the system clipboard

### Editing

-   `i`: Enter insert mode before the cursor
-   `a`: Enter insert mode after the cursor
-   `o`: Insert a new line below the current line and enter insert mode
-   `O`: Insert a new line above the current line and enter insert mode
-   `u`: Undo the last change
-   `Ctrl+r`: Redo the last undone change

### Panels

-   `Ctrl+w h`: Move to the left panel
-   `Ctrl+w j`: Move to the panel below
-   `Ctrl+w k`: Move to the panel above
-   `Ctrl+w l`: Move to the right panel
-   `Ctrl+w v`: Create a vertical split
-   `Ctrl+w s`: Create a horizontal split
-   `Ctrl+w c`: Close the current panel
-   `Ctrl+h`: Move to the left panel (alternative keybind)
-   `Ctrl+j`: Move to the panel below (alternative keybind)
-   `Ctrl+k`: Move to the panel above (alternative keybind)
-   `Ctrl+l`: Move to the right panel (alternative keybind)

## Tmux

-   `Ctrl+b %`: Create a vertical split
-   `Ctrl+b "`: Create a horizontal split
-   `Ctrl+b {arrow key}`: Switch between panes
-   `Ctrl+b c`: Create a new window
-   `Crtl+b x`: Delete current window
-   `Ctrl+b n`: Move to the next window
-   `Ctrl+b p`: Move to the previous window
