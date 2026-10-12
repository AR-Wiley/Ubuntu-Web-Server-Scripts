#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" >&2
        exit 1
fi

dir="/var/log/Install_Logs"
file="$dir/install.log"
timestamp=$(date "+%Y-%m-%d")


function validate_log_path {

        if [ ! -d "$dir" ]; then
                echo "Creating directory: $dir"
                mkdir -v "$dir"
        fi
}


function validate_log_file {

        if [ ! -e "$file"]; then
                echo "Creating file: $file"
                touch "$file"
        fi
}


function system_update {

        echo "Updating system...."
        apt-get update -y
        apt-get upgrade -y
        echo "System update completed..."
}

function nginx_install {

        if command -v nginx >/dev/null 2>&1; then
                echo "Nginx is installed.."
        else
                echo "Installing Nginx.." >> "$file"

                if ! apt-get install nginx; then
                        echo "$timestamp --Nginx installation failed..." >> "$file"
                        exit 1
                fi

                echo "$timestamp --Nginx has been installed..." >> "$file"
        fi

}


function nginx_start {

        if systemctl is-active --quiet nginx; then
                echo "$timestamp --Nginx is running..." >> "$file"
        else
                systemctl start nginx
                echo "$timestamp --Nginx has started..." >> "$file"
                systemctl enable nginx
                echo "$timestamp --Nginx is enabled..." >> "$file"
                systemctl status nginx
        fi
}

validate_log_path
validate_log_file
system_update
nginx_install
nginx_start
