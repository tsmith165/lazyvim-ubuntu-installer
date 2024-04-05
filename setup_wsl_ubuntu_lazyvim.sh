#!/bin/bash

source ./utils/logger.sh

log_info "Starting Ubuntu WSL Setup..."

# Run individual installer scripts
./installers/base_tools.sh
./installers/fonts.sh
# ./installers/vscode.sh
./installers/xfce.sh
./installers/xrdp.sh
./installers/alacritty.sh
./installers/lazyvim.sh
./installers/system_setup.sh

log_success "Ubuntu WSL Setup completed successfully"

# Output the connection details
local ip=$(get_wsl_ip)
local port=3390
log_info "--------------------------------------------------------"
log_info "GUI Connection Details:"
log_success "IP Address/Port: $ip:$port"
log_info "Use these details to connect to the GUI using an RDP client."

# Output useful commands
log_info "--------------------------------------------------------"
log_info "Useful Commands:"
log_info "To check the status of XRDP service: sudo service xrdp status"
log_info "To check the status of D-Bus service: sudo service dbus status"
log_info "To check for active RDP connections: sudo netstat -tulpn | grep 3390"
log_info "To launch Alacritty from default terminal: HOME=/home/your-username alacritty -v"
