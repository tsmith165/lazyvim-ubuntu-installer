const fs = require('fs');
const path = require('path');

const logFile = path.join(__dirname, '..', 'debug.log');
const logStream = fs.createWriteStream(logFile, { flags: 'a' });

function log(message) {
    const timestamp = new Date().toISOString();
    const logMessage = `[${timestamp}] ${message}\n`;
    logStream.write(logMessage);
    console.log(message);
}

function logError(message) {
    const timestamp = new Date().toISOString();
    const errorMessage = `[${timestamp}] ERROR: ${message}\n`;
    logStream.write(errorMessage);
    console.error(message);
}

module.exports = {
    log,
    logError,
};
