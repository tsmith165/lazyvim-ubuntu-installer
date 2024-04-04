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
        name: 'C Compiler',
        preCheck: 'gcc --version',
        installCommands: ['sudo apt-get install -y gcc'],
    },
    {
        name: 'Exuberant Ctags',
        preCheck: 'ctags --version',
        installCommands: ['sudo apt-get install -y exuberant-ctags'],
        postCheck: {
            command: 'ctags --version',
            minVersion: '5.0.0',
        },
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
        preCheck: 'py2 --version && python3 --version',
        installCommands: [
            'sudo apt-get install -y python2.7 python3',
            'mkdir -p /root/tools',
            'sudo rm -f /root/tools/python27',
            'sudo rm -f /root/tools/python310',
            'sudo ln -s /usr/bin/python2.7 /root/tools/python27',
            'sudo ln -s /usr/bin/python3 /root/tools/python310',
            'sudo rm -f /usr/local/bin/py2',
            'sudo rm -f /usr/local/bin/py3',
            'sudo ln -s /root/tools/python27 /usr/local/bin/py2',
            'sudo ln -s /root/tools/python310 /usr/local/bin/py3',
        ],
        postCheck: [
            {
                command: 'py2 --version',
                minVersion: '2.7.0',
            },
            {
                command: 'py3 --version',
                minVersion: '3.10.0',
            },
        ],
    },
    {
        name: 'xsel',
        preCheck: 'xsel --version',
        installCommands: ['sudo apt-get install -y xsel'],
        postCheck: {
            command: 'xsel --version',
            minVersion: '1.2.0',
        },
    },
];

module.exports = installSteps;
