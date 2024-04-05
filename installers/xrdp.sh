#!/bin/bash

source ../utils/logger.sh

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

main() {
  configure_xrdp || log_failure "Failed to configure XRDP"
  allow_any_user_to_start_xserver || log_failure "Failed to allow any user to start the X server"
  allow_xrdp_port_through_firewall || log_failure "Failed to allow XRDP port through the firewall"
  install_x11_dependencies || log_failure "Failed to install X11 dependencies"
}

main