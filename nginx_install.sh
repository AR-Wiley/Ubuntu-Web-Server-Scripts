#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root" >&2
        exit 1
fi


update() {

        echo "Updating and upgrading system"
        apt-get update -y
        apt-get upgrade -y
        echo "System update and upgrade completed"
}

nginx_install() {

        nginx="/etc/nginx"

        if command -v nginx >/dev/null 2>&1; then
                echo "Nginx is installed"
        else
                echo "Installing Nginx"
                apt-get install -y nginx
                echo "Nginx instalation completed"
        fi

}

nginx_start() {

        if systemctl is-active --quiet nginx; then
                echo "Nginx is Running"
        else
                systemctl start nginx
                echo "Nginx has Started"
                systemctl enable nginx
                echo "Nginx is Enabled"
                systemctl status nginx
        fi

}

update
nginx_install
nginx_start
