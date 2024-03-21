const fs = require('fs');
const path = require('path');
const { log } = require('../utils/logger');
const { runCommand } = require('./system_helper');
const plugins = require('../imports/plugins');
const keymaps = require('../imports/keymaps');
const extras = require('../imports/extras');

function cloneLazyVimStarterTemplate() {
    log('Cloning the LazyVim starter template repository...');
    const nvimDir = path.join(process.env.HOME, '.config', 'nvim');
    runCommand(`git clone https://github.com/LazyVim/starter ${nvimDir}`);
    log('LazyVim starter template cloned.');
}

function updateLazyVimConfig() {
    log('Updating the LazyVim configuration...');
    const nvimDir = path.join(process.env.HOME, '.config', 'nvim');
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
    for (const plugin of plugins) {
        log(`Adding ${plugin.name} configuration...`);
        pluginsConfig += plugin.config;
    }
    pluginsConfig += '\n}\n';

    fs.writeFileSync(pluginsConfigFile, pluginsConfig);
    log('LazyVim configuration updated.');
}

function enableLazyVimExtras() {
    log('Enabling LazyVim extras...');
    const nvimDir = path.join(process.env.HOME, '.config', 'nvim');
    const lazyConfigFile = path.join(nvimDir, 'lua', 'config', 'lazy.lua');
    let lazyConfig = fs.readFileSync(lazyConfigFile, 'utf8');

    let extrasConfig = '';
    for (const extra of extras) {
        extrasConfig += `    "${extra}",\n`;
    }

    lazyConfig = lazyConfig.replace(
        'spec = { import = "lazyvim.config.spec" },',
        `spec = { import = "lazyvim.config.spec" },
  extras = {
${extrasConfig}  },`
    );

    fs.writeFileSync(lazyConfigFile, lazyConfig);
    log('LazyVim extras enabled.');
}

function setupKeymaps() {
    log('Setting up the key mappings for copy and paste using xsel...');
    const nvimDir = path.join(process.env.HOME, '.config', 'nvim');
    const keymapsFile = path.join(nvimDir, 'lua', 'config', 'keymaps.lua');
    let keymapsConfig = fs.readFileSync(keymapsFile, 'utf8');
    keymapsConfig += keymaps;
    fs.writeFileSync(keymapsFile, keymapsConfig);
    log('Key mappings for copy and paste using xsel set up.');
}

module.exports = {
    cloneLazyVimStarterTemplate,
    updateLazyVimConfig,
    enableLazyVimExtras,
    setupKeymaps,
};
