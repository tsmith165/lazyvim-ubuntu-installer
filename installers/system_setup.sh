#!/bin/bash

source ./utils/logger.sh

bashrc_lines=(
  'alias code="code --user-data-dir /root/.vscode-root --no-sandbox"'
  'alias ala="alacritty"'
  'export PATH="$PATH:/root/tools/bun/bin"'
  'export PATH="$PATH:/root/tools/alacritty"'
  'export ALACRITTY_CONFIG="~/.config/alacritty/alacritty.toml"'
  'sudo service xrdp start'
  'sudo service dbus start'
)

update_bashrc() {
  log_info "Step: Updating bashrc..."
  for line in "${bashrc_lines[@]}"; do
    echo "$line" >> ~/.bashrc
  done
  log_success "Bashrc updated"
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

start_xrdp_and_dbus() {
  log_info "Step: Starting XRDP and D-Bus services..."
  sudo service xrdp start
  sudo service dbus start
  sudo service xrdp status
  log_success "XRDP and D-Bus services started"
}

main() {
  update_bashrc || log_failure "Failed to update bashrc"
  fix_color_managed_device_auth || log_failure "Failed to fix authentication for creating color-managed devices"
  start_xrdp_and_dbus || log_failure "Failed to start XRDP and D-Bus services"
}

main