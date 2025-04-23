#!/bin/bash
#
# This file set up installations of the languages I use for coding.
#
# bash ./install-node.sh
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

NODE_VERSION=22
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
TMP_DIR=$SCRIPT_DIR/tmp

echo "Install Node $NODE_VERSION and bun on your machine?"
echo ""

confirm_action

sudo apt update
sudo apt install $DEPS

curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x -o $TMP_DIR/nodesource_setup.sh
sudo -E bash $TMP_DIR/nodesource_setup.sh
sudo apt-get install -y nodejs
sudo corepack enable
curl -fsSL https://bun.sh/install | bash

echo ""
echo "Installation completed, printing versions"

node --version
yarn --version
pnpm --version
bun --version


