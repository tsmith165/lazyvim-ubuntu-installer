#!/usr/bin/env node

const { log } = require('./utils/logger.js');
const { checkNodeVersion, runInstallSteps } = require('./helpers/system_helper');
const {
    cloneLazyVimStarterTemplate,
    updateLazyVimConfig,
    enableLazyVimExtras,
    setupKeymaps,
    setGuiFont,
    setupDeviconsConfig,
    setupNeoTreeConfig,
    updateInitLua,
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

    // Set up the devicons configuration
    setupDeviconsConfig();

    // Update the init.lua file
    updateInitLua();
}

if (args.includes('-k') || args.includes('--keymaps') || args.length === 0) {
    // Set up the key mappings for copy and paste using xsel
    setupKeymaps();
}

log('Setup completed successfully!');
