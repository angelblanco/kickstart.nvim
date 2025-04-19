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

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
TMP_DIR=$SCRIPT_DIR/tmp
YAZI_REPO_DIR=$TMP_DIR/yazi

echo "Install yazi (latest) from source?"
echo ""

confirm_action

echo "Checking cargo and git versions"
cargo --version
git --version

echo "Installing DEPS"
sudo apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick

rm -rf $YAZI_REPO_DIR
echo "Cloning yazi repo"
git clone https://github.com/sxyazi/yazi.git $YAZI_REPO_DIR
cd $YAZI_REPO_DIR
cargo build --release --locked
sudo mv target/release/yazi target/release/ya /usr/local/bin/

echo "Printing yazi version"
echo "yazi and ya installed on /usr/local/bin remove them for uninstall"

yazi --version
ya --version

rm -rf $YAZI_REPO_DIR
