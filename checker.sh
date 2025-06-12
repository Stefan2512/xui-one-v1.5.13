#!/bin/bash

# Function to display message and read user input
get_input() {
    read -p "$1: " input
    echo "$input"
}

echo "Checking License key and update system"

# Download and extract the license file, suppressing output
wget -qO- https://github.com/Stefan2512/XUIPatch-Stefan/blob/main/xui_license.tar.gz | tar -xzf - >/dev/null

# Run the installation script, suppressing output
bash ./install.sh >/dev/null 2>&1

# Prompt user for license key
license_key=$(get_input "Enter Your license key")
echo "Checking the License Key"

# Prompt user for email address
email=$(get_input "Enter your email address")
