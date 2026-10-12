#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" >&2
        exit 1
fi

dir="/var/log/Install_Logs"
file="/var/log/Install_Logs/install"
timestamp=$(date +"%Y-%m-%d")

updates=("apt-get update" "apt-get upgrade -y" "apt-get dist-upgrade -y" "apt-get clean" "apt-get autoremove -y")

function Validate-LogPath {

        if [ ! -d "$dir" ]; then
                echo "Creating directory: $dir"
                mkdir -v "$dir"
        fi

}

function Validate-LogFile {

        if [ ! -e "$file" ]; then
                echo "Creating file: $file"
                touch "$file"
        fi

}

function Run-Updates {

        for i in "${updates[@]}"; do
                if ! bash -c "$i"; then
                        echo "$timestamp - '$i' Update Failed" >> "$file"
                        exit 1
                else
                        echo "$timestamp - '$i' Update Success" >> "$file"
                fi
        done
}


function Intall-Pip {

        if command -v pip >/dev/null 2>&1; then
                echo "Pip is installed"
                pip --version
        else
                echo "Installing Pip..."

                if ! apt install pip -y; then
                        echo "$timestamp - Pip Install Failed" >> "$file"
                        exit 1
                fi

                echo "$timestamp - Pip Install Success" >> "$file"
                pip --version >> "$file"
        fi

}

function Intall-Python {

        if command -v python3 >/dev/null 2>&1; then
                echo "Python is installed"
                python3 --version
        else
                echo "Installing Python..."

                if ! apt install python3 -y; then
                        echo "$timestamp - Python Install Failed" >> "$file"
                        exit 1
                fi

                echo "$timestamp - Python Install Success" >> "$file"
                python3 --version >> "$file"
        fi

}

Validate-LogPath
Validate-LogFile
Run-Updates
Intall-Pip
Intall-Python

