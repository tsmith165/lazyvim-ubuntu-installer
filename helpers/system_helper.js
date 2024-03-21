const { execSync } = require('child_process');
const { log, logError } = require('../utils/logger');
const installSteps = require('../imports/install_steps');

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
    runInstallSteps,
};
