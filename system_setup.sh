#!/bin/bash

# Download the required files from the Git repository
git_repo_url="https://github.com/your-username/lazyvim-ubuntu-installer.git"
utils_file="utils.sh"
logger_file="logger.sh"

uitls_git_repo_url="$git_repo_url/raw/main/utils/sytem_setup/$utils_file"
logger_git_repo_url="$git_repo_url/raw/main/utils/sytem_setup/$logger_file"

echo -e "Downloading utils file with: curl -fsSL $uitls_git_repo_url" 
curl -fsSL $uitls_git_repo_url
echo -e "Downloading logger file with: curl -fsSL $logger_git_repo_url"
curl -fsSL $logger_git_repo_url

# Load utility functions
source "./$utils_file"

# Load logging functions
source "./$logger_file"

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

# 14. Set x11vnc password
set_x11vnc_password || log_failure "Failed to set x11vnc password"

# 15. Set up x11vnc to start with GNOME desktop
setup_x11vnc_with_gnome || log_failure "Failed to set up x11vnc with GNOME desktop"

# 16. Start x11vnc with GNOME desktop
start_x11vnc_with_gnome || log_failure "Failed to start x11vnc with GNOME desktop"

# Print x11vnc password
log_orange "x11vnc password: $x11vnc_password"

# Print installed versions
log_info "Installation complete. Versions:"
echo "Node.js version: $(node -v)"
echo "Yarn version: $(yarn --version)"
echo "Bun version: $(bun -v)"
echo "Git version: $(git --version)"
echo "Visual Studio Code version: $(code --version)"