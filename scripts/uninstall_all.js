#!/usr/bin/env node

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const { log, logError } = require('../utils/logger');

function runCommand(command) {
    try {
        execSync(command, { stdio: 'inherit' });
        log(`Command executed: ${command}`);
    } catch (error) {
        logError(`Error executing command: ${command}`);
        logError(error.message);
    }
}

// Remove the LazyVim configuration directory
log('Removing the LazyVim configuration directory...');
runCommand('rm -rf ~/.config/nvim');

// Uninstall Neovim
log('Uninstalling Neovim...');
runCommand('sudo apt-get remove neovim');
runCommand('sudo apt-get autoremove');

// Remove the installed fonts
log('Removing installed fonts...');
runCommand('rm -rf ~/.local/share/fonts/JetBrainsMono.zip');
runCommand('rm -rf ~/.local/share/fonts/JetBrains*.ttf');
runCommand('fc-cache -fv');

// Uninstall Node.js and npm
log('Uninstalling Node.js and npm...');
runCommand('sudo apt-get remove nodejs npm');
runCommand('sudo apt-get autoremove');

// Remove the Node.js source list
log('Removing the Node.js source list...');
runCommand('sudo rm /etc/apt/sources.list.d/nodesource.list');

// Uninstall Yarn
log('Uninstalling Yarn...');
runCommand('sudo apt-get remove yarn');

// Uninstall Python 2.7 and 3.10
log('Uninstalling Python 2.7 and 3.10...');
runCommand('sudo apt-get remove python2.7 python3.10');
runCommand('sudo apt-get autoremove');

// Remove the Git repository
log('Removing the Git repository...');
const repoPath = path.join(__dirname, '..');
runCommand(`sudo rm -rf ${repoPath}`);

// Clean up any remaining dependencies
log('Cleaning up any remaining dependencies...');
runCommand('sudo apt-get autoremove');
runCommand('sudo apt-get autoclean');

// Update the package lists
log('Updating the package lists...');
runCommand('sudo apt-get update');

log('Uninstallation completed successfully!');
