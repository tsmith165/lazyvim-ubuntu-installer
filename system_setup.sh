#!/bin/bash

# Update package lists
sudo apt update

# Install desktop GUI (GNOME)
sudo apt install -y ubuntu-desktop

# Install Git 2+
sudo apt install -y git

# Install Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Install Yarn
npm install -g yarn

# Install Bun
curl -fsSL https://bun.sh/install | bash

# Add Bun to PATH
echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.bashrc
echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.bashrc

# Reload bashrc
source ~/.bashrc

# Install Visual Studio Code
sudo snap install --classic code

# Install VSCode extensions
code --install-extension torreysmith.copyfilepathandcontent
code --install-extension github.copilot
code --install-extension github.copilot-chat
code --install-extension bradlc.vscode-tailwindcss
code --install-extension vscode-icons-team.vscode-icons
code --install-extension quick-lint.quick-lint-js
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension yoavbls.pretty-ts-errors
code --install-extension pmndrs.pmndrs

# Create VSCode settings directory if it doesn't exist
mkdir -p ~/.config/Code/User

# Download settings.json from the GitHub repository
curl -fsSL https://raw.githubusercontent.com/tsmith165/vscode_settings/main/settings.json -o ~/.config/Code/User/settings.json

# Print installed versions
echo "Node.js version: $(node -v)"
echo "Yarn version: $(yarn --version)"
echo "Bun version: $(bun -v)"
echo "Git version: $(git --version)"
echo "Visual Studio Code version: $(code --version)"