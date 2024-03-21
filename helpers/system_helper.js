const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const { log, logError } = require('../utils/logger');
const installSteps = require('../imports/install_steps');
const bash_rc = require('../imports/bash_rc');

function runCommand(command) {
    try {
        execSync(command, { stdio: 'inherit' });
        log(`Command executed: ${command}`);
    } catch (error) {
        logError(`Error executing command: ${command}`);
        logError(error.message);
        process.exit(1);
    }
}

function checkVersion(name, command, minVersion) {
    try {
        let version = execSync(command, { encoding: 'utf8' }).trim();
        log(`${name} version: ${version}`);
        version = version.replace(/^v/, '');
        const minVersionParts = minVersion.split('.');
        const versionParts = version.split('.');
        for (let i = 0; i < minVersionParts.length; i++) {
            if (parseInt(versionParts[i]) < parseInt(minVersionParts[i])) {
                throw new Error(`${name} version ${minVersion} or higher is required.`);
            }
            if (parseInt(versionParts[i]) > parseInt(minVersionParts[i])) {
                break;
            }
        }
    } catch (error) {
        logError(`${name} version check failed: ${error.message}`);
        process.exit(1);
    }
}

function checkNodeVersion() {
    log('Checking Node.js installation...');
    try {
        checkVersion('Node.js', 'node --version', '20.0.0');
        log('Node.js is installed with the required version.');
    } catch (error) {
        logError('Node.js is not installed or does not meet the required version.');
        logError('Please install Node.js version 20.0.0 or higher and run the script again.');
        process.exit(1);
    }
}

function updateBashrc() {
    log('Updating bashrc with custom commands...');
    const bashrcPath = path.join(process.env.HOME, '.bashrc');
    let bashrcContent = fs.readFileSync(bashrcPath, 'utf8');

    for (const command of bash_rc) {
        if (!bashrcContent.includes(command)) {
            bashrcContent += `\n${command}\n`;
        }
    }

    fs.writeFileSync(bashrcPath, bashrcContent);
    log('bashrc updated with custom commands.');
}

function sourceBashrc() {
    log('Sourcing the updated .bashrc file in the current shell session...');
    execSync('source ~/.bashrc', { stdio: 'inherit' });
    log('bashrc sourced successfully.');
}

function runInstallSteps() {
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
}

module.exports = {
    runCommand,
    checkVersion,
    checkNodeVersion,
    updateBashrc,
    sourceBashrc,
    runInstallSteps,
};
