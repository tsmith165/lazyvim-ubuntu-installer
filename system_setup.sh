#!/bin/bash

#######################
# Utility Functions
#######################

update_package_lists() {
  log_info "Step: Updating package lists..."
  sudo apt update
  log_success "Package lists updated"
}

install_xterm_package() {
  log_installing "xterm package"
  sudo apt install -y xterm
  log_success "xterm package installed"
}

install_desktop_gui() {
  if ! dpkg -s ubuntu-desktop &> /dev/null; then
    log_installing "desktop GUI (GNOME)"
    sudo apt install -y ubuntu-desktop
    log_success "Desktop GUI (GNOME) installed"
  else
    log_installed "Desktop GUI (GNOME)"
    log_info "Step: Reinstalling desktop GUI (GNOME)..."
    sudo apt install --reinstall -y ubuntu-desktop
    log_success "Desktop GUI (GNOME) reinstalled"
  fi
}

install_git() {
  if ! command -v git &> /dev/null; then
    log_installing "Git 2+"
    sudo apt install -y git
    log_success "Git 2+ installed"
  else
    log_installed "Git 2+"
  fi
}

install_nodejs() {
  if ! command -v node &> /dev/null; then
    log_installing "Node.js 20.x"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
    log_success "Node.js 20.x installed"
  else
    log_installed "Node.js"
  fi
}

install_yarn() {
  if ! command -v yarn &> /dev/null; then
    log_installing "Yarn"
    sudo npm install -g yarn
    log_success "Yarn installed"
  else
    log_installed "Yarn"
  fi
}

install_bun() {
  if ! command -v bun &> /dev/null; then
    log_installing "Bun"
    curl -fsSL https://bun.sh/install | bash
    log_success "Bun installed"
  else
    log_installed "Bun"
  fi
}

add_bun_to_path() {
  if ! echo $PATH | grep -q "$HOME/.bun"; then
    log_info "Step: Adding Bun to PATH..."
    echo 'export BUN_INSTALL="$HOME/.bun"' >> ~/.bashrc
    echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
    log_success "Bun added to PATH"
  else
    log_installed "Bun is already in PATH, skipping addition"
  fi
}

install_vscode() {
  if ! command -v code &> /dev/null; then
    log_installing "Visual Studio Code"
    sudo snap install --classic code
    log_success "Visual Studio Code installed"
  else
    log_installed "Visual Studio Code"
  fi
}

install_vscode_extensions() {
  log_info "Step: Installing VSCode extensions..."
  code --user-data-dir /root/.vscode-root --no-sandbox --install-extension torreysmith.copyfilepathandcontent || log_failure "Failed to install extension: torreysmith.copyfilepathandcontent"
  code --user-data-dir /root/.vscode-root --no-sandbox --install-extension github.copilot || log_failure "Failed to install extension: github.copilot"
  code --user-data-dir /root/.vscode-root --no-sandbox --install-extension github.copilot-chat || log_failure "Failed to install extension: github.copilot-chat"
  code --user-data-dir /root/.vscode-root --no-sandbox --install-extension bradlc.vscode-tailwindcss || log_failure "Failed to install extension: bradlc.vscode-tailwindcss"
  code --user-data-dir /root/.vscode-root --no-sandbox --install-extension vscode-icons-team.vscode-icons || log_failure "Failed to install extension: vscode-icons-team.vscode-icons"
  code --user-data-dir /root/.vscode-root --no-sandbox --install-extension quick-lint.quick-lint-js || log_failure "Failed to install extension: quick-lint.quick-lint-js"
  code --user-data-dir /root/.vscode-root --no-sandbox --install-extension ms-python.python || log_failure "Failed to install extension: ms-python.python"
  code --user-data-dir /root/.vscode-root --no-sandbox --install-extension ms-python.vscode-pylance || log_failure "Failed to install extension: ms-python.vscode-pylance"
  code --user-data-dir /root/.vscode-root --no-sandbox --install-extension yoavbls.pretty-ts-errors || log_failure "Failed to install extension: yoavbls.pretty-ts-errors"
  code --user-data-dir /root/.vscode-root --no-sandbox --install-extension pmndrs.pmndrs || log_failure "Failed to install extension: pmndrs.pmndrs"
  log_success "VSCode extensions installed"
}

create_vscode_settings_dir() {
  log_info "Step: Creating VSCode settings directory..."
  mkdir -p ~/.config/Code/User
  log_success "VSCode settings directory created"
}

download_settings_json() {
  log_info "Step: Downloading settings.json..."
  curl -fsSL https://raw.githubusercontent.com/tsmith165/vscode_settings/main/settings.json -o ~/.config/Code/User/settings.json
  log_success "settings.json downloaded"
}

install_x11vnc() {
  log_installing "x11vnc package"
  sudo apt install -y x11vnc
  log_success "x11vnc package installed"
}

setup_x11vnc_with_gnome() {
  log_info "Step: Setting up x11vnc to start with GNOME desktop..."
  mkdir -p ~/.vnc
  
  log_info "Checking if Xorg server is already running on display :1..."
  if [ -f /tmp/.X1-lock ]; then
    log_orange "An Xorg server is already active on display :1. Proceeding without starting a new one."
  else
    log_info "Starting Xorg display server on display :1"
    sudo Xorg :1 &
    sleep 5 # Wait a bit to ensure Xorg is ready
  fi
  
  cat > ~/.vnc/xstartup <<EOF
#!/bin/sh

# Start the GNOME desktop environment on display :1
export DISPLAY=:1
gnome-session &

# Start x11vnc server
x11vnc -auth /root/.Xauthority -display :1 -rfbport 5901 -forever -shared -bg -usepw -o /root/.vnc/x11vnc.log
EOF
  chmod +x ~/.vnc/xstartup
  log_success "x11vnc setup completed with Xorg display server"
}

get_ip_address() {
  ip_address=$(hostname -I | awk '{print $1}')
  echo $ip_address
}

#######################
# Logging Functions
#######################

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
ORANGE='\033[0;33m'
NC='\033[0m' # No Color

log_info() {
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${GREEN}[INFO] $1${NC}"
}

log_failure() {
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${RED}[FAILURE] $1${NC}"
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${RED}Exiting the script due to the above failure.${NC}"
  exit 1
}

log_success() {
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${GREEN}[SUCCESS] $1${NC}"
}

log_orange() {
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${ORANGE}[INFO] $1${NC}"
}

log_installing() {
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${ORANGE}[INSTALLING] $1${NC}"
}

log_installed() {
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${YELLOW}[INSTALLED] $1${NC}"
}

#######################
# Main Function
#######################

main_process() {
  # 1. Update package lists
  update_package_lists || log_failure "Failed to update package lists"

  # 2. Install xterm package
  install_xterm_package || log_failure "Failed to install xterm package"

  # 3. Install desktop GUI (GNOME)
  install_desktop_gui || log_failure "Failed to install desktop GUI (GNOME)"

  # 4. Install Git
  install_git || log_failure "Failed to install Git"

  # 5. Install Node.js
  install_nodejs || log_failure "Failed to install Node.js"

  # 6. Install Yarn
  install_yarn || log_failure "Failed to install Yarn"

  # 7. Install Bun
  install_bun || log_failure "Failed to install Bun"

  # 8. Add Bun to PATH
  add_bun_to_path || log_failure "Failed to add Bun to PATH"

  # 9. Install Visual Studio Code
  install_vscode || log_failure "Failed to install Visual Studio Code"

  # 10. Install VSCode extensions
  install_vscode_extensions || log_failure "Failed to install VSCode extensions"

  # 11. Create VSCode settings directory
  create_vscode_settings_dir || log_failure "Failed to create VSCode settings directory"

  # 12. Download settings.json
  download_settings_json || log_failure "Failed to download settings.json"

  # 13. Install x11vnc
  install_x11vnc || log_failure "Failed to install x11vnc"

  # 14. Set up x11vnc to start with GNOME desktop
  setup_x11vnc_with_gnome || log_failure "Failed to set up x11vnc with GNOME desktop"

  # Get the IP address
  ip_address=$(get_ip_address)

  # Print installed versions
  log_info "--------------------------------------------------------"
  log_info "Installation complete. Versions:"
  echo "Node.js version: $(node -v)"
  echo "Yarn version: $(yarn --version)"
  echo "Bun version: $(bun -v)"
  echo "Git version: $(git --version)"
  echo "Visual Studio Code version: $(code --version)"

  # Print connection details
  log_info "VNC Connection Details:"
  echo "VNC IP: $ip_address"
  echo "VNC Port: 5901"

  log_success "System setup completed successfully"
  log_info "Run the following commands to set the VNC password and start the VNC server:"
  log_info "1. Set VNC password: x11vnc -storepasswd ~/.vnc/passwd"
  log_info "2. Start VNC server: ~/.vnc/xstartup &"
  log_info "You can now connect to the VNC server using the IP address and port mentioned above."
}

#######################
# Script Execution
#######################

main_process