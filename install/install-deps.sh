#!/bin/bash
#
# This file set up installations of the languages I use for coding with no 
# external tools.
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

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

echo "Install all dependencies? You will be prompted for sudo password and indiviudally for each lang"
echo ""

confirm_action

bash $SCRIPT_DIR/install-basics.sh
bash $SCRIPT_DIR/install-node.sh
bash $SCRIPT_DIR/install-php.sh
bash $SCRIPT_DIR/install-golang.sh
bash $SCRIPT_DIR/install-rust.sh
