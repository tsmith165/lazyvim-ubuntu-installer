const installSteps = [
    {
        name: 'Neovim',
        preCheck: 'nvim --version',
        installCommands: [
            'sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen',
            'git clone https://github.com/neovim/neovim.git',
            'cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_EXTRA_FLAGS="-DUSE_LUAJIT=ON" && sudo make install',
        ],
        postCheck: {
            command: 'nvim --version',
            minVersion: '0.9.0',
        },
    },
    {
        name: 'Git',
        preCheck: 'git --version',
        installCommands: ['sudo apt-get install -y git'],
        postCheck: {
            command: 'git --version',
            minVersion: '2.19.0',
        },
    },
    {
        name: 'Fontconfig',
        preCheck: 'fc-cache --version',
        installCommands: ['sudo apt-get install -y fontconfig'],
    },
    {
        name: 'JetBrains Mono Nerd Font',
        preCheck: 'fc-list | grep -i "JetBrains Mono"',
        installCommands: [
            'mkdir -p ~/.local/share/fonts',
            'cd ~/.local/share/fonts && curl -fLo "JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip',
            'cd ~/.local/share/fonts && unzip JetBrainsMono.zip',
            'fc-cache -fv',
        ],
    },
    {
        name: 'C Compiler',
        preCheck: 'gcc --version',
        installCommands: ['sudo apt-get install -y gcc'],
    },
    {
        name: 'Node.js',
        preCheck: 'node --version',
        installCommands: ['curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -', 'sudo apt-get install -y nodejs'],
        postCheck: {
            command: 'node --version',
            minVersion: '20.0.0',
        },
    },
    {
        name: 'Python',
        preCheck: 'python2.7 --version && python3.10 --version',
        installCommands: ['sudo apt-get install -y python2.7 python3.10'],
        postCheck: [
            {
                command: 'python2.7 --version',
                minVersion: '2.7.0',
            },
            {
                command: 'python3.10 --version',
                minVersion: '3.10.0',
            },
        ],
    },
    {
        name: 'Yarn',
        preCheck: 'yarn --version',
        installCommands: ['sudo npm install -g yarn'],
        postCheck: {
            command: 'yarn --version',
            minVersion: '1.0.0',
        },
    },
    {
        name: 'Set NVIM_TTY environment variable',
        preCheck: 'grep -q "export NVIM_TTY" ~/.bashrc || grep -q "export NVIM_TTY" ~/.zshrc',
        installCommands: ['echo "export NVIM_TTY=$(tty)" >> ~/.bashrc', 'echo "export NVIM_TTY=$(tty)" >> ~/.zshrc'],
    },
];

module.exports = installSteps;
