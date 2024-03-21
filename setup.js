#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const { log, logError } = require('./utils/logger');
const { runCommand, checkVersion } = require('./utils/helpers');
const installSteps = require('./utils/installSteps');
const pluginConfigs = require('./utils/pluginConfigs');

// Check if Node.js is installed with the required version
log('Checking Node.js installation...');
try {
    checkVersion('Node.js', 'node --version', '20.0.0');
    log('Node.js is installed with the required version.');
} catch (error) {
    logError('Node.js is not installed or does not meet the required version.');
    logError('Please install Node.js version 20.0.0 or higher and run the script again.');
    process.exit(1);
}

for (const step of installSteps) {
    log(`Checking ${step.name}...`);

    try {
        execSync(step.preCheck, { stdio: 'ignore' });
        log(`${step.name} is already installed. Skipping installation.`);
    } catch (error) {
        log(`Installing ${step.name}...`);
        for (const command of step.installCommands) {
            runCommand(command);
        }

        if (step.postCheck) {
            if (Array.isArray(step.postCheck)) {
                for (const check of step.postCheck) {
                    checkVersion(step.name, check.command, check.minVersion);
                }
            } else {
                checkVersion(step.name, step.postCheck.command, step.postCheck.minVersion);
            }
        }

        log(`${step.name} installation completed.`);
    }
}

// Install xclip for clipboard support
log('Installing xclip...');
runCommand('sudo apt-get install -y xclip');
log('xclip installation completed.');

// Clone the LazyVim starter template repository
log('Cloning the LazyVim starter template repository...');
const nvimDir = path.join(process.env.HOME, '.config', 'nvim');
runCommand(`git clone https://github.com/LazyVim/starter ${nvimDir}`);
log('LazyVim starter template cloned.');

// Update the LazyVim configuration
log('Updating the LazyVim configuration...');
const pluginsConfigDir = path.join(nvimDir, 'lua', 'plugins');
const pluginsConfigFile = path.join(pluginsConfigDir, 'init.lua');

// Create the plugins directory if it doesn't exist
if (!fs.existsSync(pluginsConfigDir)) {
    fs.mkdirSync(pluginsConfigDir, { recursive: true });
}

// Create the init.lua file if it doesn't exist
if (!fs.existsSync(pluginsConfigFile)) {
    fs.writeFileSync(pluginsConfigFile, '-- LazyVim plugins configuration\n\nreturn {\n');
}

let pluginsConfig = fs.readFileSync(pluginsConfigFile, 'utf8');

for (const plugin of pluginConfigs) {
    log(`Adding ${plugin.name} configuration...`);
    pluginsConfig += plugin.config;
}

pluginsConfig += '\n}\n';

fs.writeFileSync(pluginsConfigFile, pluginsConfig);
log('LazyVim configuration updated.');

// Enable the lazyvim.plugins.extras.lsp.none-ls extra
log('Enabling the lazyvim.plugins.extras.lsp.none-ls extra...');
const lazyConfigFile = path.join(nvimDir, 'lua', 'config', 'lazy.lua');
let lazyConfig = fs.readFileSync(lazyConfigFile, 'utf8');

lazyConfig = lazyConfig.replace(
    'spec = { import = "lazyvim.config.spec" },',
    `spec = { import = "lazyvim.config.spec" },
  extras = {
    "lazyvim.plugins.extras.lsp.none-ls",
  },`
);

fs.writeFileSync(lazyConfigFile, lazyConfig);
log('lazyvim.plugins.extras.lsp.none-ls extra enabled.');

// Configure Neovim to use the clipboard provider
log('Configuring Neovim to use the clipboard provider...');
const initConfigFile = path.join(nvimDir, 'init.lua');
let initConfig = fs.readFileSync(initConfigFile, 'utf8');

initConfig += `
-- Enable clipboard support
vim.opt.clipboard = 'unnamedplus'
`;

fs.writeFileSync(initConfigFile, initConfig);
log('Neovim clipboard configuration updated.');

log('Setup completed successfully!');
