#!/bin/zsh

# aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# bindkey initialization
bindkey -d # reset key bindings
bindkey -e # set emacs key bindings

# editor
export EDITOR='vim'

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# coreutils, findutils, moreutils
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix findutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix moreutils)/libexec/bin:$PATH"

export MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"
export MANPATH="$(brew --prefix findutils)/libexec/gnuman:$MANPATH"
export MANPATH="$(brew --prefix moreutils)/libexec/man:$MANPATH"

# VOLTA
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

# Jetbrains Toolbox (Automatically added by Jetbrains Toolbox)
export PATH="$PATH:/Users/dorayaki/Library/Application Support/JetBrains/Toolbox/scripts"

# Docker (Automatically added by Docker Desktop)
fpath=(/Users/dorayaki/.docker/completions $fpath)
autoload -Uz compinit
compinit
