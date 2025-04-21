#!/bin/bash
#
# bash ./install-php.sh
#
# Install php in Ubuntu. Elevated permissions with sudo are mandatory.
#

set -e

# Basic confirmation module before executing the script.
confirm_action() {
    read -p "Are you sure you want to continue? (y/n): " choice
    case "$choice" in
        [Yy]|[Yy][Ee][Ss])
            echo "Continuing with the action..."
            ;;
        [Nn]|[Nn][Oo])
            echo "Exiting the program."
            exit 1
            ;;
        *)
            echo "Invalid choice. Please enter 'y' or 'n'."
            confirm_action
            ;;
    esac
}


PHP_VERSION=8.4

echo "Install  php $PHP_VERSION ad composer?"
echo ""

confirm_action

sudo apt update
sudo add-apt-repository ppa:ondrej/php
sudo apt install php$PHP_VERSION php$PHP_VERSION-mbstring php$PHP_VERSION-curl php$PHP_VERSION-mbstring php$PHP_VERSION-zip

# Composer installation
echo "Instaling composer"
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet
rm composer-setup.php
sudo mv composer.phar /usr/local/bin/composer

echo ""
echo "Installation completed, printing version"

echo "PHP Version:"
php --version


