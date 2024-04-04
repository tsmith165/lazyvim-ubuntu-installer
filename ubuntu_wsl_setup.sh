#!/bin/bash

#######################
# Configuration
#######################

bashrc_lines=(
  'alias code="code --user-data-dir /root/.vscode-root --no-sandbox"'
  'alias ala="alacritty"'
  'export PATH="$PATH:/root/tools/bun/bin"'
  'export PATH="$PATH:/root/tools/alacritty"'
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
  log_info "Step: Adding Alacritty PPA..."
  sudo add-apt-repository ppa:mmstick76/alacritty -y
  sudo apt update
  log_installing "Alacritty via PPA"
  sudo apt install -y alacritty
  log_success "Alacritty installed via PPA"
}

configure_alacritty_font() {
  log_info "Step: Configuring Alacritty font..."
  mkdir -p ~/.config/alacritty
  cat > ~/.config/alacritty/alacritty.yml <<EOF
# Full Screen
window:
 dimensions:
   columns: 0
   lines: 0
 padding:
   x: 0
   y: 0
 startup_mode: Fullscreen

# Font Configuration
font:
 normal:
   family: "Fira Code"
   style: Regular
 bold:
   family: "Fira Code"
   style: Bold
 italic:
   family: "Fira Code"
   style: Italic
 size: 14.0
 offset:
   x: 0
   y: 0
 glyph_offset:
   x: 0
   y: 0
 use_thin_strokes: true

# Color Scheme
colors:
 primary:
   background: '#1d2021'
   foreground: '#d5c4a1'
 normal:
   black:   '#1d2021'
   red:     '#fb4934'
   green:   '#b8bb26'
   yellow:  '#fabd2f'
   blue:    '#83a598'
   magenta: '#d3869b'
   cyan:    '#8ec07c'
   white:   '#d5c4a1'
 bright:
   black:   '#665c54'
   red:     '#fb4934'
   green:   '#b8bb26'
   yellow:  '#fabd2f'
   blue:    '#83a598'
   magenta: '#d3869b'
   cyan:    '#8ec07c'
   white:   '#fbf1c7'

# Key Bindings
key_bindings:
 - { key: V,        mods: Control|Shift, action: Paste            }
 - { key: C,        mods: Control|Shift, action: Copy             }
 - { key: Q,        mods: Command,       action: Quit             }
 - { key: N,        mods: Command,       action: SpawnNewInstance }

# Cursor
cursor:
 style: Block
 unfocused_hollow: true

# Mouse
mouse:
 hide_when_typing: true

# Background Opacity
background_opacity: 1.0

# Shell
shell:
 program: /bin/bash
 args:
   - --login

# Bracketed paste
bracketed_paste: false

# GPU Acceleration (disable for now)
hardware_acceleration: false
EOF
  log_success "Alacritty font configured"
}

update_bashrc() {
  log_info "Step: Updating bashrc..."
  for line in "${bashrc_lines[@]}"; do
    echo "$line" >> ~/.bashrc
  done
  log_success "Bashrc updated"
}

install_fira_code_nerd_font() {
  if ! fc-list | grep -qi "FiraCode Nerd Font"; then
    log_installing "Fira Code Nerd Font"
    mkdir -p ~/.local/share/fonts
    curl -fLo ~/.local/share/fonts/FiraCodeNerdFontMono-Regular.ttf https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFontMono-Regular.ttf
    fc-cache -fv
    log_success "Fira Code Nerd Font installed"
  else
    log_installed "Fira Code Nerd Font"
  fi
}

create_alacritty_desktop_icon() {
  log_info "Step: Creating Alacritty desktop icon..."
  cat > ~/Desktop/alacritty.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Alacritty
Exec=alacritty
Icon=utilities-terminal
Terminal=false
Categories=System;TerminalEmulator;
EOF
  chmod +x ~/Desktop/alacritty.desktop
  log_success "Alacritty desktop icon created"
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
  chmod +x setup.js
  ./setup.js
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

  sudo systemctl enable xrdp
  sudo systemctl enable dbus
  log_success "XRDP configured"
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
  sudo systemctl start xrdp
  sudo systemctl start dbus
  sudo systemctl status xrdp
  log_success "XRDP and D-Bus services started"
}

# Get the IP address of the WSL instance
get_wsl_ip() {
  local ip=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
  echo "$ip"
}

# Output the connection details
output_connection_details() {
  local ip=$(get_wsl_ip)
  local port=3390
  
  log_info "--------------------------------------------------------"
  log_info "GUI Connection Details:"
  log_info "IP Address: $ip"
  log_info "Port: $port"
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

  # 7. Download settings.json
  download_settings_json || log_failure "Failed to download settings.json"

  # 8. Install Alacritty
  install_alacritty || log_failure "Failed to install Alacritty"

  # 9. Configure Alacritty font
  configure_alacritty_font || log_failure "Failed to configure Alacritty font"

  # 10. Update bashrc
  update_bashrc || log_failure "Failed to update bashrc"

  # Source the updated bashrc file
  source ~/.bashrc

  # 11. Install Fira Code Nerd Font
  install_fira_code_nerd_font || log_failure "Failed to install Fira Code Nerd Font"

  # 12. Create Alacritty desktop icon
  create_alacritty_desktop_icon || log_failure "Failed to create Alacritty desktop icon"

  # 13. Clone LazyVim Ubuntu Installer repository
  clone_lazyvim_installer_repo || log_failure "Failed to clone LazyVim Ubuntu Installer repository"

  # 14. Run setup.js script
  run_setup_js_script || log_failure "Failed to run setup.js script"

  # 15. Install XFCE and XRDP components
  install_xfce_and_xrdp || log_failure "Failed to install XFCE and XRDP components"

  # 16. Configure XRDP
  configure_xrdp || log_failure "Failed to configure XRDP"

  # 17. Fix authentication for creating color-managed devices
  fix_color_managed_device_auth || log_failure "Failed to fix authentication for creating color-managed devices"

  # 18. Install Google Chrome
  install_google_chrome || log_failure "Failed to install Google Chrome"

  # 19. Start XRDP and D-Bus services
  start_xrdp_and_dbus || log_failure "Failed to start XRDP and D-Bus services"

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
}

#######################
# Script Execution
#######################

main_process