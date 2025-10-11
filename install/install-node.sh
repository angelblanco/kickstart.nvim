#!/bin/bash
#
# This file set up installation of Node JS and several package managers. 
# Normally you will call it from your non-root user, elevated permisson
# will be granted with sudo.
#
# bash ./install-node.sh
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

# You can configure this variables if needed
NODE_VERSION=24
NPM_PREFIX="~/.npm-global"


SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
TMP_DIR=$SCRIPT_DIR/tmp

echo "Install Node $NODE_VERSION and bun on your machine?"
echo ""

confirm_action

sudo apt update
sudo apt install $DEPS

curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x -o $TMP_DIR/nodesource_setup.sh
sudo -E bash $TMP_DIR/nodesource_setup.sh
rm -rf $TMP_DIR

sudo apt-get install -y nodejs
sudo corepack enable

mkdir -p ~/.npm-global
npm config set prefix $NPM_PREFIX
echo "Npm prefix set to $NPM_PREFIX"

curl -fsSL https://bun.sh/install | bash

echo ""
echo "Installation completed, printing versions"

node --version
yarn --version
pnpm --version
bun --version


