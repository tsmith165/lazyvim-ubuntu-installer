const { execSync } = require('child_process');
const { log, logError } = require('./logger');

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

module.exports = {
    runCommand,
    checkVersion,
};
