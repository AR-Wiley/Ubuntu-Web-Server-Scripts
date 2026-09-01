#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
        echo "You must be root to run this script"
        exit 1
fi

while true; do
        read -r -p "Enter a username: " user_name

        if [[ -n "$user_name" ]]; then
                break
        fi

        echo "Please provide username"
done

password="${RANDOM}${RANDOM}"

function Validate-User() {

        local username=$1

        if id "$username" &>/dev/null; then
                echo "User '$username' already exists"
                exit 1
        fi
}

function Add-User() {

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

Validate-User "$user_name"
Add-User "$user_name" "$password"
