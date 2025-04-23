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

echo "Install $DEPS ?"
echo ""

confirm_action

sudo apt update
sudo apt install $DEPS
