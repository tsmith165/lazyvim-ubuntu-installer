#!/bin/bash

source ./utils/logger.sh

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

main() {
  create_vscode_settings_dir || log_failure "Failed to create VSCode settings directory"
  download_settings_json || log_failure "Failed to download settings.json"
}

main