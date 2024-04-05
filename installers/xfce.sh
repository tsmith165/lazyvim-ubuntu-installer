#!/bin/bash

# Get the directory of the current script and use that to source the shell logger
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(dirname "$script_dir")"
source "$project_root/utils/shell_logger.sh"

install_xfce_and_xrdp() {
  log_info "Step: Installing XFCE and RDP components..."
  sudo apt update
  sudo apt install -y xrdp xfce4 xfce4-goodies
  log_success "XFCE and RDP components installed"
}

create_xfce_appearance_script() {
  log_info "Step: Creating XFCE appearance script..."

  sudo tee /usr/local/bin/set_xfce_appearance.sh > /dev/null <<EOT
#!/bin/bash

# Set the GTK theme to Greybird Dark
xfconf-query -c xsettings -p /Net/ThemeName -s "Greybird-dark"

# Set the window manager theme to Greybird Dark
xfconf-query -c xfwm4 -p /general/theme -s "Greybird-dark"

# Set the icon theme to elementary Xfce Dark
xfconf-query -c xsettings -p /Net/IconThemeName -s "elementary-xfce-dark"

# Set the font to JetBrains Mono Nerd Font
xfconf-query -c xsettings -p /Gtk/FontName -s "JetBrains Mono Nerd Font 10"
xfconf-query -c xfwm4 -p /general/title_font -s "JetBrains Mono Nerd Font Bold 10"
EOT

  sudo chmod +x /usr/local/bin/set_xfce_appearance.sh

  log_success "XFCE appearance script created"
}

configure_xfce_autostart() {
  log_info "Step: Configuring XFCE autostart..."

  sudo tee /etc/xdg/autostart/set_xfce_appearance.desktop > /dev/null <<EOT
[Desktop Entry]
Type=Application
Name=Set XFCE Appearance
Exec=/usr/local/bin/set_xfce_appearance.sh
Terminal=false
NoDisplay=true
EOT

  log_success "XFCE autostart configured"
}

main() {
  install_xfce_and_xrdp || log_failure "Failed to install XFCE and XRDP components"
  create_xfce_appearance_script || log_failure "Failed to create XFCE appearance script"
  configure_xfce_autostart || log_failure "Failed to configure XFCE autostart"
}

main