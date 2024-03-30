#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

log() {
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] $1"
}

success() {
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${GREEN}Step Successful:${NC} $1"
}

failure() {
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${RED}Step Failed:${NC} $1"
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${RED}Exiting the script due to the above failure.${NC}"
  exit 1
}

installed() {
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${YELLOW}$1 is already installed, skipping installation${NC}"
}

installing() {
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${ORANGE}Installing $1...${NC}"
}

# Update package lists
log "Step: Updating package lists..."
sudo apt update || failure "Failed to update package lists"
success "Package lists updated"

# Install xterm package
installing "xterm package"
sudo apt install -y xterm || failure "Failed to install xterm package"
success "xterm package installed"

# Check if desktop GUI (GNOME) is already installed
if ! dpkg -s ubuntu-desktop &> /dev/null; then
  installing "desktop GUI (GNOME)"
  sudo apt install -y ubuntu-desktop || failure "Failed to install desktop GUI (GNOME)"
  success "Desktop GUI (GNOME) installed"
else
  installed "Desktop GUI (GNOME)"
  log "Step: Reinstalling desktop GUI (GNOME)..."
  sudo apt install --reinstall -y ubuntu-desktop || failure "Failed to reinstall desktop GUI (GNOME)"
  success "Desktop GUI (GNOME) reinstalled"
fi

# Install Git 2+ (if not already installed)
if ! command -v git &> /dev/null; then
  installing "Git 2+"
  sudo apt install -y git || failure "Failed to install Git 2+"
  success "Git 2+ installed"
else
  installed "Git 2+"
fi

# Install Node.js 20.x (if not already installed)
if ! command -v node &> /dev/null; then
  installing "Node.js 20.x"
  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - || failure "Failed to set up Node.js 20.x repository"
  sudo apt install -y nodejs || failure "Failed to install Node.js 20.x"
  success "Node.js 20.x installed"
else
  installed "Node.js"
fi

# Install Yarn (if not already installed)
if ! command -v yarn &> /dev/null; then
  installing "Yarn"
  sudo npm install -g yarn || failure "Failed to install Yarn"
  success "Yarn installed"
else
  installed "Yarn"
fi

# Install Bun (if not already installed)
if ! command -v bun &> /dev/null; then
  installing "Bun"
  curl -fsSL https://bun.sh/install | bash || failure "Failed to install Bun"
  success "Bun installed"
else
  installed "Bun"
fi

# Check if Bun is already in PATH
if ! echo $PATH | grep -q "$HOME/.bun"; then
  log "Step: Adding Bun to PATH..."
  echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.bashrc
  echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.bashrc
  source ~/.bashrc
  success "Bun added to PATH"
else
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${YELLOW}Bun is already in PATH, skipping addition${NC}"
fi

# Install Visual Studio Code (if not already installed)
if ! command -v code &> /dev/null; then
  installing "Visual Studio Code"
  sudo snap install --classic code || failure "Failed to install Visual Studio Code"
  success "Visual Studio Code installed"
else
  installed "Visual Studio Code"
fi

# Install VSCode extensions
log "Step: Installing VSCode extensions..."
code --user-data-dir /root/.vscode-root --no-sandbox --install-extension torreysmith.copyfilepathandcontent || failure "Failed to install extension: torreysmith.copyfilepathandcontent"
code --user-data-dir /root/.vscode-root --no-sandbox --install-extension github.copilot || failure "Failed to install extension: github.copilot"
code --user-data-dir /root/.vscode-root --no-sandbox --install-extension github.copilot-chat || failure "Failed to install extension: github.copilot-chat"
code --user-data-dir /root/.vscode-root --no-sandbox --install-extension bradlc.vscode-tailwindcss || failure "Failed to install extension: bradlc.vscode-tailwindcss"
code --user-data-dir /root/.vscode-root --no-sandbox --install-extension vscode-icons-team.vscode-icons || failure "Failed to install extension: vscode-icons-team.vscode-icons"
code --user-data-dir /root/.vscode-root --no-sandbox --install-extension quick-lint.quick-lint-js || failure "Failed to install extension: quick-lint.quick-lint-js"
code --user-data-dir /root/.vscode-root --no-sandbox --install-extension ms-python.python || failure "Failed to install extension: ms-python.python"
code --user-data-dir /root/.vscode-root --no-sandbox --install-extension ms-python.vscode-pylance || failure "Failed to install extension: ms-python.vscode-pylance"
code --user-data-dir /root/.vscode-root --no-sandbox --install-extension yoavbls.pretty-ts-errors || failure "Failed to install extension: yoavbls.pretty-ts-errors"
code --user-data-dir /root/.vscode-root --no-sandbox --install-extension pmndrs.pmndrs || failure "Failed to install extension: pmndrs.pmndrs"
success "VSCode extensions installed"

# Create VSCode settings directory if it doesn't exist
log "Step: Creating VSCode settings directory..."
mkdir -p ~/.config/Code/User || failure "Failed to create VSCode settings directory"
success "VSCode settings directory created"

# Download settings.json from the GitHub repository
log "Step: Downloading settings.json..."
curl -fsSL https://raw.githubusercontent.com/tsmith165/vscode_settings/main/settings.json -o ~/.config/Code/User/settings.json || failure "Failed to download settings.json"
success "settings.json downloaded"

# Install VNC server (if not already installed)
if ! command -v vncserver &> /dev/null; then
  installing "VNC server"
  sudo apt install -y tightvncserver || failure "Failed to install VNC server"
  success "VNC server installed"
else
  installed "VNC server"
fi

# Install missing font packages
installing "missing font packages"
sudo apt install -y xfonts-75dpi xfonts-100dpi || failure "Failed to install missing font packages"
success "Missing font packages installed"

# Install tigervnc-standalone-server package
installing "tigervnc-standalone-server package"
sudo apt install -y tigervnc-standalone-server || failure "Failed to install tigervnc-standalone-server package"
success "tigervnc-standalone-server package installed"

# Install D-Bus package
installing "D-Bus package"
sudo apt install -y dbus-x11 || failure "Failed to install D-Bus package"
success "D-Bus package installed"

# Install gnome-panel and gnome-settings-daemon packages
installing "gnome-panel and gnome-settings-daemon packages"
sudo apt install -y gnome-panel gnome-settings-daemon || failure "Failed to install gnome-panel and gnome-settings-daemon packages"

# Check if gnome-panel is available in the system path
if ! command -v gnome-panel &> /dev/null; then
  failure "gnome-panel is not available in the system path"
fi

success "gnome-panel and gnome-settings-daemon packages installed"

# Generate random VNC password
vnc_password=$(openssl rand -base64 8)

# Set VNC password
log "Step: Setting up VNC password..."
printf "$vnc_password\n$vnc_password\n" | vncpasswd || failure "Failed to set VNC password"
success "VNC password set"

# Configure VNC server
log "Step: Configuring VNC server..."
mkdir -p ~/.vnc
echo 'localhost = no' > ~/.vnc/config
echo 'geometry = 1920x1080' >> ~/.vnc/config
echo 'depth = 24' >> ~/.vnc/config
success "VNC server configured"

# Create VNC xstartup file
log "Step: Creating VNC xstartup file..."
cat > ~/.vnc/xstartup <<EOF
#!/bin/sh

export SHELL=/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey

vncconfig -iconic &
exec gnome-session

EOF
chmod +x ~/.vnc/xstartup
success "VNC xstartup file created"

# Restart VNC server
log "Step: Restarting VNC server..."
vncserver -list | grep -q ":1" && vncserver -kill :1
vncserver :1 || failure "Failed to start VNC server"
success "VNC server started"

# Print VNC password
echo -e "${ORANGE}VNC password:${NC} $vnc_password"

# Print installed versions
log "Installation complete. Versions:"
echo "Node.js version: $(node -v)"
echo "Yarn version: $(yarn --version)"
echo "Bun version: $(bun -v)"
echo "Git version: $(git --version)"
echo "Visual Studio Code version: $(code --version)"