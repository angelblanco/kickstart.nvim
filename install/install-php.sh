#!/bin/bash
#
# bash ./install-php.sh
#
# Install PHP (from packages.sury.org) and Composer on Ubuntu.
# Elevated permissions with sudo are mandatory.
#

set -euo pipefail

PHP_VERSION="8.5"
KEYRING="/usr/share/keyrings/debsuryorg-archive-keyring.gpg"
SOURCE_FILE="/etc/apt/sources.list.d/php.sources"

# Basic confirmation module before executing the script.
confirm_action() {
    while true; do
        read -r -p "Are you sure you want to continue? (y/n): " choice
        case "$choice" in
            [Yy]|[Yy][Ee][Ss]) echo "Continuing..."; return 0 ;;
            [Nn]|[Nn][Oo])     echo "Exiting."; exit 1 ;;
            *)                 echo "Invalid choice. Please enter 'y' or 'n'." ;;
        esac
    done
}

echo "Install PHP $PHP_VERSION and Composer?"
echo ""
confirm_action

# --- Prerequisites ---------------------------------------------------------
sudo apt update
sudo apt install -y ca-certificates curl unzip

# --- Sury signing key (official keyring package, auto-updates on rotation) -
TMP_DEB="$(mktemp --suffix=.deb)"
curl -fsSLo "$TMP_DEB" https://packages.sury.org/debsuryorg-archive-keyring.deb
sudo dpkg -i "$TMP_DEB"
rm -f "$TMP_DEB"

# --- Sury repository --------------------------------------------------------
CODENAME="$(. /etc/os-release && echo "$VERSION_CODENAME")"

sudo tee "$SOURCE_FILE" > /dev/null <<EOF
Types: deb
URIs: https://packages.sury.org/php/
Suites: $CODENAME
Components: main
Architectures: $(dpkg --print-architecture)
Signed-By: $KEYRING
EOF

sudo apt update

# --- PHP --------------------------------------------------------------------
# Use -cli instead of the bare "phpX.Y" metapackage, which pulls in Apache.
sudo apt install -y \
    "php${PHP_VERSION}-cli" \
    "php${PHP_VERSION}-mbstring" \
    "php${PHP_VERSION}-curl" \
    "php${PHP_VERSION}-zip" \
    "php${PHP_VERSION}-xml"

# Make this version the default "php" command
sudo update-alternatives --set php "/usr/bin/php${PHP_VERSION}"

# --- Composer ---------------------------------------------------------------
echo "Installing Composer..."
WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT
cd "$WORKDIR"

EXPECTED_CHECKSUM="$(curl -fsSL https://composer.github.io/installer.sig)"
curl -fsSLo composer-setup.php https://getcomposer.org/installer
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
    >&2 echo "ERROR: Invalid Composer installer checksum"
    exit 1
fi

php composer-setup.php --quiet
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

# --- Done -------------------------------------------------------------------
echo ""
echo "Installation completed."
echo ""
php --version
echo ""
composer --version
