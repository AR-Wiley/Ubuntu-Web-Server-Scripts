#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
        echo "You must be root to run this script"
        exit 1
fi

Add-User() {

        local username="$1"

        local password
        password="${RANDOM}${RANDOM}"

        if [[ -z "$username" ]]; then
                echo "Username not provided"
                echo "Usage: $0 <username>"
                exit 1
        fi

        if id "$username" &>/dev/null; then
                echo "User '$username' already exits"
                exit 1
        fi

        if ! useradd -m -c "User: $username" "$username"; then
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

Add-User "$1"


