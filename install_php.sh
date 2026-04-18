#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" >&2
        exit 1
fi

function validate_log_path {

        dir="/var/log/Install_Logs"

        if [ ! -d "$dir" ]; then
                echo "Creating directory: $dir"
                mkdir -v "$dir"
        fi

}

function validate_log_file {

        file="/var/log/Install_Logs/install"

        if [ ! -e "$file" ]; then
                echo "Creating file: $file"
                touch "$file"
        fi

}

function run_updates {

        file="/var/log/Install_Logs/install"

        timestamp=$(date +"%Y-%m-%d")

        updates=("apt-get update"
                "apt-get upgrade -y"
                "apt-get dist-upgrade -y"
                "apt-get clean"
                "apt-get autoremove -y")

        for i in "${updates[@]}"; do
                if ! eval "$i"; then
                        echo "$timestamp - '$i' Failed" >> "$file"
                        exit 1
                else
                        echo "$timestamp - '$i' Success" >> "$file"
                fi
        done

}

function install_php {

        file="/var/log/Install_Logs/install"

        timestamp=$(date +"%Y-%m-%d")

        if command -v php >/dev/null 2>&1; then
                echo "PHP is installed..."
                php --version
        else
                echo "Installing PHP..." >> "$file"

                if ! apt install php -y --no-install-recommends php-cli php-fpm php-common; then
                        echo "$timestamp - PHP Installation Failed..." >> "$file"
                        exit 1
                fi

                echo "$timestamp - PHP has been installed..." >> "$file"
                php --version >> "$file"
        fi
}

function install_php_packages {

        file="/var/log/Install_Logs/install"

        timestamp=$(date +"%Y-%m-%d")

        packages=("php-mysql" "php-xml" "php-curl" "php-mbstring" "php-zip")

        for i in "${packages[@]}"; do

                echo "Checking if $i is installed..."

                if dpkg -s "$i" &>/dev/null; then
                        echo "$i is already installed."
                else
                        echo "$timestamp - $i is not installed. Installing..." >> "$file"
                        if sudo apt install "$i" -y; then
                                echo "$timestamp - $i has been installed" >> "$file"
                        else
                                echo "$timestamp - Failed to install $i." >> "$file"
                                exit
                        fi
                fi
        done

}

function verify_php_fpm {

        if systemctl is-active --quiet php*-fpm; then
                echo "PHP is running..."
        else
                systemctl start php*-fpm
                echo "PHP has started..."
                systemctl enable php*-fpm
                echo "PHP is enabled..."
                systemctl status php*-fpm
        fi

}

function verfiy_php_modules {

        packages=("php-mysql" "php-xml" "php-curl" "php-mbstring" "php-zip")

        for i in "${packages[@]}"; do

                echo "Checking $i module..."

                if php -m | grep -q -i "$i"; then
                        echo "$i module is loaded..."
                else
                        echo "Module not found... Installing..."
                        apt install -y "$i"
                fi
        done
}

validate_log_path
validate_log_file
run_updates
install_php
install_php_packages
verify_php_fpm 
verfiy_php_modules

