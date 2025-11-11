#!/bin/bash

update() {

        echo "Installing Update"

        if ! sudo apt update; then
                echo "Update Failed"
                exit 1
        fi

        echo "Updated Completed"

        echo "Installing Upgrade"

        if ! sudo apt upgrade -y; then
                echo "upgrade failed"
                exit 1
        fi

        echo "Upgrade Completed"

}

apache_install() {

        apache_path="/usr/sbin/apache2"

        if [[ ! -x "$apache_path" ]]; then
                echo "Apache not found. Running installer script..."
                /home/install_apach.sh
        else
                echo "Apache found and installed at $apache_path"
        fi
}

php_install() {

        php_path="/usr/bin/php"

        if [[ -x $php_path ]]; then
                echo "PHP is installed"
                php --verion
        else
                echo "Installing PHP..."
                if ! suod apt install php -y; then
                        echo "PHP Installation Failed!"
                        exit 1
                fi

                echo "PHP has been installed"
                php --version
        fi
}

php_package_install() {

        packages=("php-cli" "php-cgi" "php-mysql" "php-pgsql")

        for i in "${packages[@]}"; do

                echo "Checking if $i is installed..."

                if dpkg -s "$i" &>/dev/null; then
                        echo "$i is already installed."
                else
                        echo "$i is not installed. Installing..."
                        if sudo apt install "i" -y; then
                                echo "$i has been installed"
                        else
                                echo "Failed to installe $i."
                                exit
                        fi
                fi
        done
}

update
apache_install
php_install
php_package_install


