#!/bin/bash
#
# This file set up installations needed for nvim to work on WSL over ubuntu.
#
# PLEASE Insepect the file before actually running it:
#
# bash ./install-nvim.sh
#
# Elevated permissions with sudo are mandatory.
#
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

NVIM_PATH=/usr/local/bin/nvim
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
DEPS="build-essential ripgrep"
TMP_DIR="$SCRIPT_DIR/tmp"
NVIM_ARCH=$(uname -m)

echo "This script will install several utilities in your computer."
echo "Is recommended that you inspect this script before continuing"
echo "Operations:"

echo " - Install apt dependecies: $DEPS"
echo " - Install fuse package for appimage"
echo " - Download latest neovim stable to $TMP_DIR"
echo " - Install neovim as app-image in $NVIM_PATH"

echo "SCRIPT_DIR: $SCRIPT_DIR"
echo "TMP_DIR: $TMP_DIR"
echo "NVIM_PATH: $NVIM_PATH"
echo "NVIM_ARCH: $NVIM_ARCH"

confirm_action

echo "Installing $DEPS"
sudo apt update
sudo apt install $DEPS

echo "Installing fuse"
sudo add-apt-repository universe
sudo apt install libfuse2

# Install neovim to usr

echo "Installing neovim in latest neovim stable with appimage"
mkdir -p $TMP_DIR
wget "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-$NVIM_ARCH.appimage" -O $TMP_DIR/nvim
sudo chmod +x $TMP_DIR/nvim
sudo mv $TMP_DIR/nvim $NVIM_PATH
echo "Neovim installed under $TMP_DIR/nvim"

echo ""
echo "---"
echo "WARN: If you are using WSL you probably need to install win32yank."
echo "If so open a PowerShell and run"
echo "> winget install win32yank"
echo ""
