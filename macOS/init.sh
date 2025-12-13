#!/bin/bash

set -eux

##########################
# Shell script functions #
##########################

function cp_if_not_exists() {
  local src_file="$1"
  local dest_file="$2"

  if [ ! -f "$dest_file" ]; then
    cp "$src_file" "$dest_file"
  else
    echo "$dest_file already exists. Skipping copy."
  fi
}

############
# Homebrew #
############

# Install command-line tools and GUI applications using Homebrew.

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew update && brew upgrade

# core utilities
brew install coreutils
brew install moreutils
brew install findutils

# command-line tools
brew install awscli
brew install bash
brew install bitwarden-cli
brew install brew-php-switcher
brew install bun
brew install curl
brew install ffmpeg
brew install gh
brew install git
brew install gnupg
brew install go
brew install jq
brew install mkcert
brew install ollama
brew install rust
brew install sqlite
brew install tree
brew install vim
brew install volta
brew install wget
brew install yq

# GUI applications
brew install --cask bitwarden
brew install --cask claude
brew install --cask claude-code
brew install --cask discord
brew install --cask firefox
brew install --cask font-jetbrains-mono
brew install --cask google-chrome
brew install --cask google-drive
brew install --cask docker-desktop
brew install --cask hhkb
brew install --cask jetbrains-toolbox
brew install --cask microsoft-edge
brew install --cask postman
brew install --cask raycast
brew install --cask steam
brew install --cask visual-studio-code
brew install --cask warp
brew install --cask yubico-authenticator
brew install --cask yubico-yubikey-manager
brew install --cask zoom

brew cleanup

##############
# Zsh Setup  #
##############

# Copy the .zshrc configuration if it doesn't exist
cp_if_not_exists ./macOS/.zshrc ~/.zshrc

#############
# git Setup #
#############

# Set global git configurations
cp_if_not_exists ./macOS/git/.gitconfig ~/.gitconfig

# github.com
mkdir -p ~/src/github.com
cp_if_not_exists ./macOS/git/.gitconfig ~/src/github.com/.gitconfig

# Set global git ignore file
cp_if_not_exists ./macOS/git/ignore ~/.config/git/ignore

####################
# GitHub CLI Setup #
####################

gh auth login

#####################
# Claude Code Setup #
#####################
