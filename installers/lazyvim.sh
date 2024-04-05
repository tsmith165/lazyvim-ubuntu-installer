#!/bin/bash

# Get the directory of the current script and use that to source the shell logger
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(dirname "$script_dir")"
source "$project_root/utils/shell_logger.sh"

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
  node setup_lazyvim.js
  log_success "setup.js script execution completed"
}

main() {
  local repo_dir=$(pwd)
  clone_lazyvim_installer_repo || log_failure "Failed to clone LazyVim Ubuntu Installer repository"
  run_setup_js_script || log_failure "Failed to run setup.js script"
  cd "$repo_dir" || log_failure "Failed to navigate back to the repo directory"
}

main