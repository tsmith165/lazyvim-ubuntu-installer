#!/usr/bin/env node

const { log } = require('./imports/logger');
const { checkNodeVersion, runInstallSteps } = require('./helpers/system_helper');
const { cloneLazyVimStarterTemplate, updateLazyVimConfig, enableLazyVimExtras, setupKeymaps } = require('./helpers/install_helper');

// Check if Node.js is installed with the required version
checkNodeVersion();

// Run the install steps
runInstallSteps();

// Clone the LazyVim starter template repository
cloneLazyVimStarterTemplate();

// Update the LazyVim configuration
updateLazyVimConfig();

// Enable the lazyvim.plugins.extras.lsp.none-ls extra
enableLazyVimExtras();

// Set up the key mappings for copy and paste using xsel
setupKeymaps();

log('Setup completed successfully!');
