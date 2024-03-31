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
        name: 'Fira Code Nerd Font',
        preCheck: 'fc-list | grep -i "Fira Code Nerd Font"',
        installCommands: [
            'mkdir -p ~/.local/share/fonts',
            'cd ~/.local/share/fonts && curl -fLo "Fira Code Regular Nerd Font Complete.ttf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/Regular/FiraCodeNerdFontMono-Regular.ttf',
            'fc-cache -fv',
        ],
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
        preCheck: 'py2 --version && py3 --version',
        installCommands: [
            'sudo apt-get install -y python2.7 python3.9',
            'mkdir -p /root/tools',
            'if [ -e /root/tools/python27 ]; then sudo rm /root/tools/python27; fi',
            'if [ -e /root/tools/python39 ]; then sudo rm /root/tools/python39; fi',
            'sudo ln -s /usr/bin/python2.7 /root/tools/python27',
            'sudo ln -s /usr/bin/python3.9 /root/tools/python39',
            'if [ -e /usr/local/bin/py2 ]; then sudo rm /usr/local/bin/py2; fi',
            'if [ -e /usr/local/bin/py3 ]; then sudo rm /usr/local/bin/py3; fi',
            'sudo ln -s /root/tools/python27 /usr/local/bin/py2',
            'sudo ln -s /root/tools/python39 /usr/local/bin/py3',
        ],
        postCheck: [
            {
                command: 'py2 --version',
                minVersion: '2.7.0',
            },
            {
                command: 'py3 --version',
                minVersion: '3.9.0',
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
