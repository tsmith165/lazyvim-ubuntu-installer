#!/bin/bash

# Load logging functions
source "./logger.sh"

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

set_x11vnc_password() {
  log_info "Step: Setting up x11vnc password..."
  x11vnc_password=$(openssl rand -base64 8)
  printf "$x11vnc_password\n$x11vnc_password\n" | x11vnc -storepasswd ~/.vnc/x11vnc.passwd
  log_success "x11vnc password set"
}

setup_x11vnc_with_gnome() {
  log_info "Step: Setting up x11vnc to start with GNOME desktop..."
  mkdir -p ~/.vnc
  cat > ~/.vnc/xstartup <<EOF
#!/bin/sh

# Start the GNOME desktop environment
gnome-session &

# Start x11vnc server
x11vnc -auth /root/.Xauthority -display :1 -rfbport 5901 -forever -shared -bg -rfbauth ~/.vnc/x11vnc.passwd -o ~/.vnc/x11vnc.log
EOF
  chmod +x ~/.vnc/xstartup
  log_success "x11vnc setup completed"
}

start_x11vnc_with_gnome() {
  log_info "Step: Starting x11vnc with GNOME desktop..."
  ~/.vnc/xstartup &
  log_success "x11vnc and GNOME desktop started"
}