#!/bin/bash
#
# This file set up installations of a ZHS shell using starship automatically writing
# the zshrc path.
#
# bash ./install-terminal.sh
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


DEPS="zsh curl git build-essential ripgrep ca-certificates apt-transport-https software-properties-common"
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
CUR_USER=$USER
ZSHRC_FILE="$HOME/.zshrc"
TMP_DIR=$SCRIPT_DIR/tmp
NODE_VERSION=22

echo "This script will install several utilities in your computer."
echo "Is recommended that you inspect this script before continuing"
echo "Operations:"

echo " - Install apt dependecies: $DEPS"
echo " - Download latest zsh, spaceship and nodeJS"
echo " - Install zsh and modify the $ZSHRC_FILE file if needed"

echo "SCRIPT_DIR: $SCRIPT_DIR"
echo "TMP_DIR: $TMP_DIR"
echo "HOME: $HOME"
echo "USER: $USER"
echo "NODE VERSION: $NODE_VERSION"
echo "ZSHRC: $ZSHRC_FILE"

confirm_action

rm -rf TMP_DIR

echo "Installign $DEPS"
sudo apt update
sudo apt install $DEPS

echo "Installing/Updating OMZ"

if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "OMZ already installed, skipping"
else
    echo "When seeing use as default, please select NO or rerun the script afterwards"

    confirm_action

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if command -v omz &> /dev/null; then
    echo "Running omz update..."
    omz update
fi

echo "Installing Starship"

curl -sS https://starship.rs/install.sh | sh

touch $ZSHRC_FILE


# Define the content to insert between the markers
NEW_CONTENT=$(cat << 'EOF'
# ****
## [[ DO NOT REMOVE THE LINE ABOVE OR THIS CONTENT ]]
eval "$(starship init zsh)"

export EDITOR=neovim
export VISUAL=neovim

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# snap
export PATH=$PATH:/snap/bin

# go
export PATH=$PATH:/usr/local/go/bin

if command -v go &> /dev/null; then
    export PATH="$PATH:$(go env GOPATH)/bin"
fi

# rust 
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# Alias
alias v=nvim
alias n=nvim
alias psg="ps aux | grep -v 'grep' | grep"
alias ralias="source ~/.zshrc"
## [[ DO NOT REMOVE THE LINE BELOW OR THIS CONTENT ]]
# ****
EOF
)

# Remove the existing section between markers if it exists
sed -i '/## AUTO-PROFILE START/,/## AUTO-PROFILE END/d' "$ZSHRC_FILE"

# Add the new content with the markers
echo -e "## AUTO-PROFILE START\n$NEW_CONTENT\n## AUTO-PROFILE END\n" >> "$ZSHRC_FILE"