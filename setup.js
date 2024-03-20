#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');
const { log, logError } = require('./utils/logger');
const { runCommand, checkVersion } = require('./utils/helpers');
const installSteps = require('./utils/installSteps');
const pluginConfigs = require('./utils/pluginConfigs');

// Check if the script is being run from install.sh
if (process.env.LAZYVIM_INSTALLER !== 'true') {
    logError('This script should only be run from the install.sh script.');
    logError('Please run the install.sh script instead.');
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

// Clone the LazyVim starter template repository
log('Cloning the LazyVim starter template repository...');
const nvimDir = path.join(process.env.HOME, '.config', 'nvim');
runCommand(`git clone https://github.com/LazyVim/starter ${nvimDir}`);
log('LazyVim starter template cloned.');

// Update the LazyVim configuration
log('Updating the LazyVim configuration...');
const pluginsConfigFile = path.join(nvimDir, 'lua', 'plugins', 'init.lua');
let pluginsConfig = fs.readFileSync(pluginsConfigFile, 'utf8');

for (const plugin of pluginConfigs) {
    log(`Adding ${plugin.name} configuration...`);
    pluginsConfig += plugin.config;
}

fs.writeFileSync(pluginsConfigFile, pluginsConfig);
log('LazyVim configuration updated.');

log('Setup completed successfully!');
