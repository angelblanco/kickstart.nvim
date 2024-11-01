#!/bin/bash
#
# This file set up installations of the languages I use for coding.
#
# bash ./install-deps.sh
#
# Elevated permissions with sudo are mandatory.
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


DEPS="curl git build-essential ripgrep ca-certificates apt-transport-https software-properties-common unzip p7zip-full p7zip-rar jq"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CUR_USER=$USER
ZSHRC_FILE="$HOME/.zshrc"
TMP_DIR=$SCRIPT_DIR/tmp
NODE_VERSION=22
PHP_VERSION=8.3

echo "Install Node $NODE_VERSION, php $PHP_VERSION, composer, golang (latest) and rust (latest) on your machine to the given versions"
echo ""

confirm_action

sudo apt update
sudo apt install $DEPS

curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x -o $TMP_DIR/nodesource_setup.sh
sudo -E bash $TMP_DIR/nodesource_setup.sh
sudo apt-get install -y nodejs
node --version
sudo corepack enable
yarn --version
pnpm --version
curl -fsSL https://bun.sh/install | bash
bun --version

sudo add-apt-repository ppa:ondrej/php
sudo apt install php$PHP_VERSION

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

echo "Installing go through snap"
sudo snap install go --classic

echo "Installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh


echo ""
echo "Installation completed, printing version"

echo "PHP Version:"
php --version
echo "Node Version:"
node --version
echo "Yarn Version:"
yarn --version
echo "Pnpm Version:"
pnpm --version
echo "Go Version"
go version
echo "Rustc Version"
rustc --version
echo "Bun Version"
bun --version

