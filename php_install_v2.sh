#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" >&2
        exit 1
fi


function Validate_Log_Path {

        dir="/var/log/Install_Logs"

        if [ ! -d "$dir" ]; then
                echo "Creating directory: $dir"
                mkdir -v "$dir"
        fi

}

function Validate_Log_File {

        file="/var/log/Install_Logs/install"

        if [ ! -e "$file" ]; then
                echo "Creating file: $file"
                touch "$file"
        fi

}

function Run_Updates {

        file="/var/log/Install_Logs/install"

        updates=("apt-get update"
                "apt-get upgrade -y"
                "apt-get dist-upgrade -y"
                "apt-get clean"
                "apt-get autoremove -y")

        timestamp=$(date +"%Y-%m-%d")

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
                echo "PHP is installed..." >> "$file"
                php --version >> "$file"
        else
                echo "Installing PHP..." >> "$file"

                if ! apt install php -y --no-install-recommends php-cli php-fpm php-common; then
                        echo "PHP Installation Failed..."
                        exit 1
                fi

                echo "PHP has been installed..."
                php --version
        fi
}

function install_php_packages {

        php-mysql, php-xml, php-curl, php-mbstring, php-zip



}

