#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

log() {
  echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1"
}

success() {
  echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Step Successful: $1"
}

failure() {
  echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Step Failed: $1"
  echo "[$(date +%Y-%m-%d\ %H:%M:%S)] Exiting the script due to the above failure."
  exit 1
}

# Update package lists
log "Step: Updating package lists..."
sudo apt update || failure "Failed to update package lists"
success "Package lists updated"

# Install desktop GUI (GNOME)
log "Step: Installing desktop GUI (GNOME)..."
sudo apt install -y ubuntu-desktop || failure "Failed to install desktop GUI (GNOME)"
success "Desktop GUI (GNOME) installed"

# Install Git 2+
log "Step: Installing Git 2+..."
sudo apt install -y git || failure "Failed to install Git 2+"
success "Git 2+ installed"

# Install Node.js 20.x
log "Step: Installing Node.js 20.x..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - || failure "Failed to set up Node.js 20.x repository"
sudo apt install -y nodejs || failure "Failed to install Node.js 20.x"
success "Node.js 20.x installed"

# Install Yarn
log "Step: Installing Yarn..."
npm install -g yarn || failure "Failed to install Yarn"
success "Yarn installed"

# Install Bun
log "Step: Installing Bun..."
curl -fsSL https://bun.sh/install | bash || failure "Failed to install Bun"
success "Bun installed"

# Add Bun to PATH
log "Step: Adding Bun to PATH..."
echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.bashrc
echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
success "Bun added to PATH"

# Install Visual Studio Code
log "Step: Installing Visual Studio Code..."
sudo snap install --classic code || failure "Failed to install Visual Studio Code"
success "Visual Studio Code installed"

# Install VSCode extensions
log "Step: Installing VSCode extensions..."
code --install-extension torreysmith.copyfilepathandcontent || failure "Failed to install extension: torreysmith.copyfilepathandcontent"
code --install-extension github.copilot || failure "Failed to install extension: github.copilot"
code --install-extension github.copilot-chat || failure "Failed to install extension: github.copilot-chat"
code --install-extension bradlc.vscode-tailwindcss || failure "Failed to install extension: bradlc.vscode-tailwindcss"
code --install-extension vscode-icons-team.vscode-icons || failure "Failed to install extension: vscode-icons-team.vscode-icons"
code --install-extension quick-lint.quick-lint-js || failure "Failed to install extension: quick-lint.quick-lint-js"
code --install-extension ms-python.python || failure "Failed to install extension: ms-python.python"
code --install-extension ms-python.vscode-pylance || failure "Failed to install extension: ms-python.vscode-pylance"
code --install-extension yoavbls.pretty-ts-errors || failure "Failed to install extension: yoavbls.pretty-ts-errors"
code --install-extension pmndrs.pmndrs || failure "Failed to install extension: pmndrs.pmndrs"
success "VSCode extensions installed"

# Create VSCode settings directory if it doesn't exist
log "Step: Creating VSCode settings directory..."
mkdir -p ~/.config/Code/User || failure "Failed to create VSCode settings directory"
success "VSCode settings directory created"

# Download settings.json from the GitHub repository
log "Step: Downloading settings.json..."
curl -fsSL https://raw.githubusercontent.com/tsmith165/vscode_settings/main/settings.json -o ~/.config/Code/User/settings.json || failure "Failed to download settings.json"
success "settings.json downloaded"

# Install VNC server
log "Step: Installing VNC server..."
sudo apt install -y tightvncserver || failure "Failed to install VNC server"
success "VNC server installed"

# Set up VNC server
log "Step: Setting up VNC server..."
vncserver || failure "Failed to set up VNC server"
success "VNC server set up"

# Print installed versions
log "Installation complete. Versions:"
echo "Node.js version: $(node -v)"
echo "Yarn version: $(yarn --version)"
echo "Bun version: $(bun -v)"
echo "Git version: $(git --version)"
echo "Visual Studio Code version: $(code --version)"