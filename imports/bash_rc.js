const bash_rc = [
    "alias cdm='cd /root/dev/main/'",
    "alias cds='cd /root/dev/scripts/'",
    `alias cdl='cd "$(ls -dt */ | head -1)"'`,
    "alias sbrc='source ~/.bashrc'",
    "alias nbrc='nvim ~/.bashrc'",
    // Add more bashrc commands here as needed
];

module.exports = bash_rc;
