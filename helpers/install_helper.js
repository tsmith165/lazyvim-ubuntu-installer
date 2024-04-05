const fs = require('fs');
const path = require('path');
const { log } = require('./utils/logger');
const { runCommand } = require('./system_helper');
const plugins = require('./imports/plugins');
const keymaps = require('./imports/keymaps');
const extras = require('./imports/extras');
const neoTreeConfig = require('./imports/neo_tree');

function cloneLazyVimStarterTemplate() {
    log('Cloning the LazyVim starter template repository...');
    const nvimDir = path.join(process.env.HOME, '.config', 'nvim');

    if (!fs.existsSync(nvimDir)) {
        runCommand(`git clone https://github.com/LazyVim/starter ${nvimDir}`);
        log('LazyVim starter template cloned.');
    } else {
        log('LazyVim starter template directory already exists. Skipping cloning.');
    }
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

    // Start with an empty plugins configuration
    let pluginsConfig = '-- LazyVim plugins configuration\n\nreturn {\n';

    const enabledPlugins = plugins.filter((plugin) => !plugin.disabled);

    for (const plugin of enabledPlugins) {
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

function setGuiFont() {
    log('Setting the Vim guifont to JetBrains Mono Nerd Font...');
    const nvimDir = path.join(process.env.HOME, '.config', 'nvim');
    const initLuaFile = path.join(nvimDir, 'init.lua');

    let initLuaConfig = fs.readFileSync(initLuaFile, 'utf8');
    initLuaConfig += "\nvim.opt.guifont = 'JetBrainsMono Nerd Font:h12'\n";

    fs.writeFileSync(initLuaFile, initLuaConfig);
    log('Vim guifont set to JetBrains Mono Nerd Font.');
}

function setupNeoTreeConfig() {
    log('Setting up the neo-tree configuration...');
    const nvimDir = path.join(process.env.HOME, '.config', 'nvim');
    const neoTreeConfigDir = path.join(nvimDir, 'lua', 'config');
    const neoTreeConfigFile = path.join(neoTreeConfigDir, 'neo-tree.lua');
    const initLuaFile = path.join(nvimDir, 'init.lua');

    // Create the config directory if it doesn't exist
    if (!fs.existsSync(neoTreeConfigDir)) {
        fs.mkdirSync(neoTreeConfigDir, { recursive: true });
    }

    fs.writeFileSync(neoTreeConfigFile, neoTreeConfig);
    log('neo-tree configuration file created.');

    // Add the neo-tree configuration to init.lua
    let initLuaContent = fs.readFileSync(initLuaFile, 'utf8');
    if (!initLuaContent.includes('require("config.neo-tree")')) {
        initLuaContent += '\nrequire("config.neo-tree")\n';
        fs.writeFileSync(initLuaFile, initLuaContent);
        log('neo-tree configuration added to init.lua.');
    } else {
        log('neo-tree configuration already exists in init.lua. Skipping addition.');
    }
}

function setupDeviconsConfig() {
    log('Setting up the nvim-web-devicons configuration...');
    const nvimDir = path.join(process.env.HOME, '.config', 'nvim');
    const deviconsConfigFile = path.join(__dirname, '..', 'imports', 'devicons.lua');
    const targetDeviconsConfigFile = path.join(nvimDir, 'lua', 'config', 'devicons.lua');

    fs.copyFileSync(deviconsConfigFile, targetDeviconsConfigFile);
    log('nvim-web-devicons configuration file copied.');
}

function updateInitLua() {
    log('Updating the init.lua file...');
    const nvimDir = path.join(process.env.HOME, '.config', 'nvim');
    const initLuaFile = path.join(nvimDir, 'init.lua');

    let initLuaContent = fs.readFileSync(initLuaFile, 'utf8');

    // Add the devicons configuration
    if (!initLuaContent.includes('require("config.devicons")')) {
        initLuaContent += '\nrequire("config.devicons")\n';
    }

    fs.writeFileSync(initLuaFile, initLuaContent);
    log('init.lua file updated.');
}

module.exports = {
    cloneLazyVimStarterTemplate,
    updateLazyVimConfig,
    enableLazyVimExtras,
    setupKeymaps,
    setGuiFont,
    setupDeviconsConfig,
    setupNeoTreeConfig,
    updateInitLua,
};
