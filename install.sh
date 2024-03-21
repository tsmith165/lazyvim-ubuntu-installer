#!/bin/bash

# Function to check if Node.js is installed with the required version
check_nodejs_installation() {
    if command -v node &> /dev/null
    then
        current_version=$(node -v)
        required_version="v20.0.0"

        if [ "$(printf '%s\n' "$required_version" "$current_version" | sort -V | head -n1)" = "$required_version" ]; then
            echo "Node.js $current_version is installed and meets the required version."
            return 0
        else
            echo "Node.js is installed but does not meet the required version."
            echo "Required version: $required_version"
            echo "Current version: $current_version"
            return 1
        fi
    else
        echo "Node.js is not installed."
        return 1
    fi
}

# Check if Node.js is already installed with the required version
check_nodejs_installation

if [ $? -eq 0 ]; then
    echo "Node.js is already installed with the required version. Skipping installation."
else
    # Install Node.js
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs

    # Check if Node.js installation was successful
    if [ $? -eq 0 ]; then
        echo "Node.js installation completed successfully."
    else
        echo "Node.js installation failed."
        exit 1
    fi

    # Check if installed Node.js meets the required version
    check_nodejs_installation

    if [ $? -ne 0 ]; then
        echo "Installed Node.js version does not meet the required version."
        exit 1
    fi
fi

echo "Node.js is installed and meets the required version."

# Set the environment variable to indicate running from install.sh
export LAZYVIM_INSTALLER=true

# Run the Node.js script
echo "Launching the Node.js script..."
node setup.js
. ~/.bashrc