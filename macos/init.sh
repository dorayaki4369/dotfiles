#!/bin/bash

# macOS 初期化スクリプト
# 使い方: ./macos/init.sh

set -eux

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

cd "$DOTFILES_DIR"

##########################
# ヘルパー関数           #
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

# Homebrewがインストールされていなければインストール
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Brewfileを使ってパッケージをインストール
brew update && brew upgrade
brew bundle --file=./macos/Brewfile
brew cleanup

##############
# Zsh Setup  #
##############

# oh-my-zshをインストール（未インストールの場合）
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# zsh-autosuggestionsプラグインをインストール（未インストールの場合）
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# .zshrcをコピー
cp_if_not_exists ./macos/zsh/.zshrc ~/.zshrc

#############
# git Setup #
#############

# グローバルgit設定をコピー
cp_if_not_exists ./common/git/.gitconfig ~/.gitconfig

# github.com用の設定
mkdir -p ~/src/github.com
cp_if_not_exists ./common/git/github/.gitconfig ~/src/github.com/.gitconfig

# グローバルgit ignoreファイルをコピー
mkdir -p ~/.config/git
cp_if_not_exists ./common/git/ignore ~/.config/git/ignore

####################
# GitHub CLI Setup #
####################

gh auth login

#####################
# Claude Code Setup #
#####################

# Claude Code設定ディレクトリを作成
mkdir -p ~/.claude

# CLAUDE.md（グローバルインストラクション）をコピー
cp_if_not_exists ./common/claude/CLAUDE.md ~/.claude/CLAUDE.md

# settings.json（許可設定、フック、プラグインなど）をコピー
cp_if_not_exists ./common/claude/settings.json ~/.claude/settings.json

#####################
# macOS Defaults    #
#####################

# macOSのシステム設定を適用
./macos/defaults.sh
