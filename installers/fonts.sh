#!/bin/bash

source ../utils/logger.sh

install_fontconfig() {
  log_info "Step: Installing fontconfig..."
  sudo apt install -y fontconfig
  sudo apt install -y unzip
  log_success "fontconfig installed"
}

install_jetbrains_mono_nerd_font() {
  # if jetbrains font is installed, log that and exit.
  if fc-list | grep "JetBrainsMono Nerd Font"; then
    log_success "JetBrains Mono Nerd Font is already installed."
    return
  fi

  log_installing "JetBrains Mono Nerd Font"
  mkdir -p /usr/share/fonts/JetBrainsMonoNerdFont
  mkdir -p /tmp/fonts
  curl -fLo /tmp/fonts/JetBrainsMono.zip https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip /tmp/fonts/JetBrainsMono.zip -d /usr/share/fonts/JetBrainsMonoNerdFont/
  rm -rf /tmp/fonts
  fc-cache -fv

  # check if the font is installed
  if ! fc-list | grep "JetBrainsMono Nerd Font"; then
    log_failure "Failed to install JetBrains Mono Nerd Font"
  fi

  log_success "JetBrains Mono Nerd Font installed"
}

main() {
  install_fontconfig || log_failure "Failed to install fontconfig"
  install_jetbrains_mono_nerd_font || log_failure "Failed to install JetBrains Mono Nerd Font"
}

main