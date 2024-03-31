# LazyVim Ubuntu Installer

![LazyVim Logo](assets/lazyvim-ubuntu-installer-logo.png)

A comprehensive setup script (`ubuntu_setup.sh`) to automate the installation and configuration of a GUI environment from a headless Ubuntu 22.04 image, along with the installation of LazyVim (Neovim config) and various development tools.

## Features

-   Installs and configures a desktop GUI (GNOME) on a headless Ubuntu 22.04 image
-   Sets up VNC server (x11vnc) for remote access to the GUI environment
-   Installs and configures Alacritty terminal emulator with Fira Code Nerd Font
-   Installs Node.js, Yarn, and Bun for modern JavaScript development
-   Installs and configures Visual Studio Code with essential extensions
-   Installs and sets up LazyVim (Neovim config) with LSPs, plugins, and custom keybinds
-   Configures devicons for enhanced visual file type recognition in Neovim

## Prerequisites

Before running the setup script, ensure that your system meets the following requirements:

-   Ubuntu 22.04 (headless or server image)
-   Internet connection

## Usage

1. Run the following command to execute the system setup script:

```
curl -fsSL https://raw.githubusercontent.com/tsmith165/lazyvim-ubuntu-installer/main/ubuntu_setup.sh | bash
```

2. Set the VNC password:

```
x11vnc -storepasswd ~/.vnc/passwd
```

3. Start the VNC server:

```
~/.vnc/xstartup &
```

4. Open a VNC session using the IP address and port provided by the script, and enter the user-defined password.

5. Once connected to the VNC session, everything should be set up and ready to use

![LazyVim Logo](assets/lazyvim-screenshot.png)

## Customization

If you want to customize the LazyVim configuration, you can modify the files in the `~/.config/nvim` directory.

For information on the custom keybinds and plugins, refer to the following files:

-   [Plugin and Custom Keybinds](PLUGIN_KEYBINDS.md)
-   [Generic Vim/Tmux/Linux Keybinds](GENERIC_KEYBINDS.md)

## Troubleshooting

If you encounter any issues during the setup process, please check the log files generated by the setup script for detailed information and error messages.

## License

This project is licensed under the [MIT License](LICENSE).
