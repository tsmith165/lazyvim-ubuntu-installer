#!/bin/bash

#######################
# Configuration
#######################

bashrc_lines=(
  'alias code="code --user-data-dir /root/.vscode-root --no-sandbox"'
  'alias ala="alacritty"'
  'export PATH="$PATH:/root/tools/bun/bin"'
  'export PATH="$PATH:/root/tools/alacritty"'
  'sudo service xrdp start'
  'sudo service dbus start'
)

#######################
# Utility Functions
#######################

update_package_lists() {
  log_info "Step: Updating package lists..."
  sudo apt update
  log_success "Package lists updated"
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
    sudo npm install -g bun
    log_success "Bun installed"
  else
    log_installed "Bun"
  fi
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

install_alacritty() {
  if ! command -v alacritty &> /dev/null; then
    log_installing "Alacritty"
    local alacritty_version="0.13.2"
    local alacritty_url="https://github.com/alacritty/alacritty/archive/refs/tags/v${alacritty_version}.tar.gz"
    local alacritty_tar="/tmp/alacritty.tar.gz"
    local alacritty_dir="/tmp/alacritty-${alacritty_version}"

    # Install build dependencies
    sudo apt install -y cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

    # Install xkbcommon library
    log_installing "xkbcommon library"
    sudo apt install -y libxkbcommon-dev
    log_success "xkbcommon library installed"

    # Check if Rust and Cargo are installed
    if ! command -v rustc &> /dev/null || ! command -v cargo &> /dev/null; then
      log_installing "Rust and Cargo"
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
      source "$HOME/.cargo/env"
      log_success "Rust and Cargo installed"
    else
      log_installed "Rust and Cargo"
    fi

    # Download Alacritty source code
    if wget -O "$alacritty_tar" "$alacritty_url"; then
      # Extract the source code
      tar -xzf "$alacritty_tar" -C "/tmp"

      # Build and install Alacritty
      cd "$alacritty_dir"
      cargo build --release

      if [ -f "target/release/alacritty" ]; then
        sudo cp target/release/alacritty /usr/local/bin/
        log_success "Alacritty installed"
      else
        log_failure "Alacritty build failed"
      fi

      cd - > /dev/null

      # Clean up the downloaded source code
      rm -rf "$alacritty_dir" "$alacritty_tar"
    else
      log_failure "Failed to download Alacritty source code"
    fi
  else
    log_installed "Alacritty"
  fi
}

create_alacritty_desktop_icon() {
  log_info "Step: Creating Alacritty desktop icon..."
  cat > /usr/share/applications/alacritty.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Alacritty
Exec=alacritty
Icon=alacritty
Terminal=false
Categories=System;TerminalEmulator;
EOF
  sudo chmod +x /usr/share/applications/alacritty.desktop
  log_success "Alacritty desktop icon created"
}

download_alacritty_config() {
  log_info "Step: Downloading Alacritty configuration file..."
  local config_repo_path="./imports/alacritty.toml"
  local config_os_path="~/.config/alacritty/alacritty.toml"

  # Copy the configuration file to the Alacritty configuration directory
  log_info "Running command: cp $config_repo_path $config_os_path"
  cp "$config_repo_path" "$config_os_path" || log_failure "Failed to copy Alacritty configuration file"

  log_success "Alacritty configuration file downloaded"
}

configure_alacritty() {
  log_info "Step: Configuring Alacritty..."
  mkdir -p ~/.config/alacritty
  download_alacritty_config
  log_success "Alacritty configured with Fira Code Mono Nerd Font"
}

download_alacritty_icon() {
  log_info "Step: Downloading Alacritty icon..."
  local icon_url="https://raw.githubusercontent.com/alacritty/alacritty/master/extra/logo/alacritty-term.svg"
  local icon_path="/usr/share/icons/hicolor/scalable/apps/alacritty.svg"

  if ! wget -O "$icon_path" "$icon_url"; then
    log_failure "Failed to download Alacritty icon"
  fi

  log_success "Alacritty icon downloaded"
}

add_alacritty_to_xfce_panel() {
  log_info "Step: Adding Alacritty to XFCE panel..."

  # Create a temporary launcher file
  local launcher_file="/tmp/alacritty.desktop"
  cat > "$launcher_file" <<EOF
[Desktop Entry]
Type=Application
Name=Alacritty
Exec=alacritty
Icon=alacritty
Categories=System;TerminalEmulator;
EOF

  # Add the launcher to the panel
  xfce4-panel -r
  xfce4-panel -q -a "$(xfce4-panel-profiles)/default/panels/panel-1" \
    -p "$(xfce4-panel-profiles)/default/panels/panel-1/launcher-22" \
    -re -ln "alacritty" -if "$launcher_file"

  log_success "Alacritty added to XFCE panel"
}

configure_xfce_desktop() {
  log_info "Step: Configuring XFCE desktop..."

  # Enable icons on the desktop
  xfconf-query -c xfce4-desktop -p /desktop-icons/style -n -t string -s UNIX

  # Update XFCE desktop icon cache
  xfce4-desktop-menu-redefine --restart

  log_success "XFCE desktop configured"
}

update_library_cache() {
  log_info "Step: Updating library cache..."
  sudo ldconfig
  log_success "Library cache updated"
}

update_bashrc() {
  log_info "Step: Updating bashrc..."
  for line in "${bashrc_lines[@]}"; do
    echo "$line" >> ~/.bashrc
  done
  log_success "Bashrc updated"
}

install_fontconfig() {
  log_info "Step: Installing fontconfig..."
  sudo apt install -y fontconfig
  log_success "fontconfig installed"
}

install_fira_code_nerd_font() {
  if ! fc-list | grep -qi "FiraCodeNerdFontMono"; then
    log_installing "Fira Code Nerd Font Mono"
    mkdir -p ~/.local/share/fonts
    curl -fLo ~/.local/share/fonts/FiraCodeNerdFontMono-Regular.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Mono/Regular/FiraCodeNerdFontMono-Regular.ttf
    fc-cache -fv
    log_success "Fira Code Nerd Font Mono installed"
  else
    log_installed "Fira Code Nerd Font Mono"
  fi
}

clone_lazyvim_installer_repo() {
  log_info "Step: Cloning LazyVim Ubuntu Installer repository..."
  mkdir -p /root/dev/setup
  cd /root/dev/setup
  git clone https://github.com/tsmith165/lazyvim-ubuntu-installer.git
  cd lazyvim-ubuntu-installer
  log_success "LazyVim Ubuntu Installer repository cloned"
}

run_setup_js_script() {
  log_info "Step: Running setup.js script..."
  chmod +x setup_lazyvim.js
  ./setup_lazyvim.js
  log_success "setup.js script execution completed"
}

install_xfce_and_xrdp() {
  log_info "Step: Installing XFCE and RDP components..."
  sudo apt update
  sudo apt install -y xrdp xfce4 xfce4-goodies
  log_success "XFCE and RDP components installed"
}

configure_xrdp() {
  log_info "Step: Configuring XRDP..."
  sudo sed -i 's/3389/3390/g' /etc/xrdp/xrdp.ini
  sudo sed -i 's/max_bpp=32/#max_bpp=32\nmax_bpp=128/g' /etc/xrdp/xrdp.ini
  sudo sed -i 's/xserverbpp=24/#xserverbpp=24\nxserverbpp=128/g' /etc/xrdp/xrdp.ini
  echo xfce4-session > ~/.xsession

  sudo sed -i 's/test -x/#test -x/g' /etc/xrdp/startwm.sh
  sudo sed -i 's@exec /bin/sh@#exec /bin/sh@g' /etc/xrdp/startwm.sh
  echo '#xfce4' >> /etc/xrdp/startwm.sh
  echo 'startxfce4' >> /etc/xrdp/startwm.sh
  sed -i 's@.*if test -r /etc/profile.*@unset DBUS_SESSION_BUS_ADDRESS\n&@' /etc/xrdp/startwm.sh
  sed -i 's@.*if test -r /etc/profile.*@unset XDG_RUNTIME_DIR\n&@' /etc/xrdp/startwm.sh

  sudo update-rc.d xrdp defaults
  sudo update-rc.d dbus defaults
  log_success "XRDP configured"
}

allow_any_user_to_start_xserver() {
  log_info "Step: Allowing any user to start the X server..."
  sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config
  log_success "Any user is now allowed to start the X server"
}

allow_xrdp_port_through_firewall() {
  log_info "Step: Allowing XRDP port through the firewall..."
  sudo ufw allow 3390/tcp
  log_success "XRDP port allowed through the firewall"
}

fix_color_managed_device_auth() {
  log_info "Step: Fixing authentication for creating color-managed devices..."
  echo "[Allow Colord all Users]" >> /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
  echo "Identity=unix-user:*" >> /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
  echo "Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile" >> /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
  echo "ResultAny=no" >> /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
  echo "ResultInactive=no" >> /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
  echo "ResultActive=yes" >> /etc/polkit-1/localauthority/50-local.d/45-allow-colord.pkla
  log_success "Authentication fixed for creating color-managed devices"
}

install_google_chrome() {
  log_info "Step: Installing Google Chrome..."
  sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install ./google-chrome-stable_current_amd64.deb -y
  log_success "Google Chrome installed"
}

start_xrdp_and_dbus() {
  log_info "Step: Starting XRDP and D-Bus services..."
  sudo service xrdp start
  sudo service dbus start
  sudo service xrdp status
  log_success "XRDP and D-Bus services started"
}

install_x11_dependencies() {
  log_info "Step: Installing X11 dependencies..."
  sudo apt install -y \
    libxcb-xkb-dev \
    libxkbcommon-x11-dev \
    libxcb-keysyms1-dev \
    libxcb-icccm4-dev \
    libxcb-randr0-dev \
    libxcb-xinerama0-dev \
    libxcb-shape0-dev \
    libxcb-xfixes0-dev
  log_success "X11 dependencies installed"
}

# Get the IP address of the WSL instance
get_wsl_ip() {
  local ip=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
  echo "$ip"
}

output_useful_commands() {
  log_info "--------------------------------------------------------"
  log_info "Useful Commands:"
  log_info "To check the status of XRDP service: sudo service xrdp status"
  log_info "To check the status of D-Bus service: sudo service dbus status"
  log_info "To check for active RDP connections: sudo netstat -tulpn | grep 3390"
}

# Output the connection details
output_connection_details() {
  local ip=$(get_wsl_ip)
  local port=3390
  
  log_info "--------------------------------------------------------"
  log_info "GUI Connection Details:"
  log_success "IP Address/Port: $ip:$port"
  log_info "Use these details to connect to the GUI using an RDP client."
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
  echo -e "[$(date +%Y-%m-%d\ %H:%M:%S)] ${ORANGE}[INSTALLED] $1${NC}"
}

#######################
# Main Function
#######################

main_process() {
  # 1. Update package lists
  update_package_lists || log_failure "Failed to update package lists"

  # 2. Install Git
  install_git || log_failure "Failed to install Git"

  # 3. Install Node.js
  install_nodejs || log_failure "Failed to install Node.js"

  # 4. Install Yarn
  install_yarn || log_failure "Failed to install Yarn"

  # 5. Install Bun
  install_bun || log_failure "Failed to install Bun"

  # 6. Create VSCode settings directory
  create_vscode_settings_dir || log_failure "Failed to create VSCode settings directory"

  # 7. Install Fira Code Nerd Font Mono
  install_fira_code_nerd_font || log_failure "Failed to install Fira Code Nerd Font Mono"

  # 8. Download settings.json
  download_settings_json || log_failure "Failed to download settings.json"

  # 9. Install X11 dependencies
  install_x11_dependencies || log_failure "Failed to install X11 dependencies"

  # 10. Install Alacritty
  install_alacritty || log_failure "Failed to install Alacritty"

  # 11. Update library cache
  update_library_cache || log_failure "Failed to update library cache"

  # 12. Configure Alacritty
  configure_alacritty || log_failure "Failed to configure Alacritty"

  # 13. Update bashrc
  update_bashrc || log_failure "Failed to update bashrc"

  # Source the updated bashrc file
  source ~/.bashrc

  # 14. Install fontconfig
  install_fontconfig || log_failure "Failed to install fontconfig"

  # 15. Create Alacritty desktop icon
  create_alacritty_desktop_icon || log_failure "Failed to create Alacritty desktop icon"

  # 16. Download Alacritty icon
  download_alacritty_icon || log_failure "Failed to download Alacritty icon"

  # 17. Configure XFCE desktop
  configure_xfce_desktop || log_failure "Failed to configure XFCE desktop"

  # 18. Clone LazyVim Ubuntu Installer repository
  clone_lazyvim_installer_repo || log_failure "Failed to clone LazyVim Ubuntu Installer repository"

  # 19. Run setup.js script
  run_setup_js_script || log_failure "Failed to run setup.js script"

  # 20. Install XFCE and XRDP components
  install_xfce_and_xrdp || log_failure "Failed to install XFCE and XRDP components"

  # 21. Configure XRDP
  configure_xrdp || log_failure "Failed to configure XRDP"

  # 22. Allow any user to start the X server
  allow_any_user_to_start_xserver || log_failure "Failed to allow any user to start the X server"

  # 23. Allow XRDP port through the firewall
  allow_xrdp_port_through_firewall || log_failure "Failed to allow XRDP port through the firewall"

  # 24. Fix authentication for creating color-managed devices
  fix_color_managed_device_auth || log_failure "Failed to fix authentication for creating color-managed devices"

  # 25. Install Google Chrome
  install_google_chrome || log_failure "Failed to install Google Chrome"

  # 26. Start XRDP and D-Bus services
  start_xrdp_and_dbus || log_failure "Failed to start XRDP and D-Bus services"

  # 27. Add Alacritty to XFCE panel
  add_alacritty_to_xfce_panel || log_failure "Failed to add Alacritty to XFCE panel"

  # Print installed versions
  log_info "--------------------------------------------------------"
  log_info "Installation complete. Versions:"
  echo "Node.js version: $(node -v)"
  echo "Yarn version: $(yarn --version)"
  echo "Bun version: $(bun -v)"
  echo "Git version: $(git --version)"
  echo "Alacritty version: $(alacritty --version)"

  log_success "System setup and GUI installation completed successfully"

  # Output connection details
  output_connection_details

  # Output useful commands
  output_useful_commands
}

#######################
# Script Execution
#######################

main_process
