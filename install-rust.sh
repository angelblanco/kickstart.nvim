#!/bin/bash
#
# bash ./install-rust.sh
#
# Install rust on Ubuntu. Elevated permissions with sudo are mandatory.
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

echo "Install rust (latest)?"
echo ""

echo "Installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo ""
echo "Installation completed, printing version"

echo "Rustc Version"
rustc --version
