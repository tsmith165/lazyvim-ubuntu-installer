#!/usr/bin/env node

const { log } = require('./utils/logger');
const { checkNodeVersion, runInstallSteps, updateBashrc, sourceBashrc } = require('./helpers/system_helper');
const {
    cloneLazyVimStarterTemplate,
    updateLazyVimConfig,
    enableLazyVimExtras,
    setupKeymaps,
    setGuiFont,
    setupNeoTreeConfig,
    setupIconsConfig,
} = require('./helpers/install_helper');

const args = process.argv.slice(2);

if (args.includes('-i') || args.includes('--install') || args.length === 0) {
    // Check if Node.js is installed with the required version
    checkNodeVersion();

    // Run the install steps
    runInstallSteps();
}

if (args.length === 0) {
    // Clone the LazyVim starter template repository
    cloneLazyVimStarterTemplate();
}

if (args.includes('-p') || args.includes('--plugins') || args.length === 0) {
    // Update the LazyVim configuration
    updateLazyVimConfig();

    // Enable LazyVim extras
    enableLazyVimExtras();

    // Set the GUI font
    setGuiFont();

    // Set up the neo-tree configuration
    setupNeoTreeConfig();

    // Set up the icons configuration
    setupIconsConfig();
}

if (args.includes('-k') || args.includes('--keymaps') || args.length === 0) {
    // Set up the key mappings for copy and paste using xsel
    setupKeymaps();
}

if (args.includes('-b') || args.includes('--bashrc') || args.length === 0) {
    // Update bashrc with custom commands
    updateBashrc();

    // Source the updated bashrc file in the current shell session
    sourceBashrc();
}

log('Setup completed successfully!');
