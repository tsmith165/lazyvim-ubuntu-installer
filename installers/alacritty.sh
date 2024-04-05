#!/bin/bash

source ../utils/logger.sh

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
  local config_repo_path="../imports/alacritty.toml"
  local config_os_path="$HOME/.config/alacritty/alacritty.toml"

  # If Alacritty configuration directory does not exist, create it
  if [ ! -d "$HOME/.config/alacritty" ]; then
    log_info "Creating Alacritty configuration directory at $HOME/.config/alacritty"
    mkdir -p "$HOME/.config/alacritty"
  fi

  # If the configuration file already exists, back it up
  if [ -f "$config_os_path" ]; then
    # Add timestamp to the backup file name.
    local timestamp=$(date +"%Y%m%d%H%M%S")
    local backup_file_path="${config_os_path}.bak.${timestamp}"
    log_info "Backing up existing Alacritty configuration file to $backup_file_path"
    mv "$config_os_path" "$backup_file_path" || log_failure "Failed to back up existing Alacritty configuration file"
  fi

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

update_library_cache() {
  log_info "Step: Updating library cache..."
  sudo ldconfig
  log_success "Library cache updated"
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

main() {
  install_alacritty || log_failure "Failed to install Alacritty"
  update_library_cache || log_failure "Failed to update library cache"
  configure_alacritty || log_failure "Failed to configure Alacritty"
  create_alacritty_desktop_icon || log_failure "Failed to create Alacritty desktop icon"
  download_alacritty_icon || log_failure "Failed to download Alacritty icon"
  add_alacritty_to_xfce_panel || log_failure "Failed to add Alacritty to XFCE panel"
}

main