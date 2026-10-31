#!/bin/bash

set -euo pipefail

function validate_root() {

        if [[ $EUID -ne 0 ]]; then
                echo "This script must run as root" >&2
                exit 1
        fi
}

function validate_user() {

        local username=$1

        if id "$username" &>/dev/null; then
                echo "User '$username' already exists"
                exit 1
        fi
}

function add_user() {

        local username="$1"
        local password="$2"

        if ! useradd -m "$username"; then
                echo "Failed to create user."
                exit 1
        fi

        if ! echo "$username:$password" | chpasswd; then
                echo "Failed to set password for $username"
                exit 1
        fi

        echo "User '$username' has been created."
        echo "User '$username' password is: $password"
}

function main() {
        while true; do
                read -r -p "Enter a username: " user_name

                if [[ -n "$user_name" ]]; then
                        break
                fi

                echo "Please provide username"

                
        done

        password=$(openssl rand -base64 16)

        Validate-User "$user_name"
        Add-User "$user_name" "$password"
}

main "$@"

