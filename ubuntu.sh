#!/bin/bash
#
# This file set up installations needed for nvim to work on WSL over ubuntu.
#
# PLEASE Insepect the file before actually running it:
#
# bash ./ubuntu.sh
#
# Elevated permissions with sudo are mandatory.
#
#


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

NVIM_PATH=/usr/local/nvim
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
DEPS="build-essential ripgrep"
TMP_DIR="$SCRIPT_DIR/tmp"

echo "This script will install several utilities in your computer."
echo "Is recommended that you inspect this script before continuing"
echo "Operations:"

echo " - Install apt dependecies: $DEPS"
echo " - Install fuse package for appimage"
echo " - Download latest neovim stable to $TMP_DIR"
echo " - Install neovim as app-image in /usr/local/bin/nvim"

echo "SCRIPT_DIR: $SCRIPT_DIR"
echo "TMP_DIR: $TMP_DIR"
echo "NVIM_PATH: $NVIM_PATH"

confirm_action

echo "Installing $DEPS"
sudo apt update
sudo apt install $DEPS

echo "Installing fuse"
sudo add-apt-repository universe
sudo apt install libfuse2

# Install neovim to usr

echo "Installing neovim in latest neovim stable with appimage"
echo "TODO: "


echo ""
echo "---"
echo "WARN: If you are using WSL you probably need to install win32yank."
echo "If so open a PowerShell and run"
echo "> winget install win32yank"
echo ""
