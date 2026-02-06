#!/bin/zsh

################
# oh-my-zsh    #
################

export ZSH="$HOME/.oh-my-zsh"

# テーマ設定
# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# プラグイン設定
# https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
plugins=(
    aliases              # エイリアス一覧を表示する `acs` コマンド
    git                  # gitコマンドのエイリアス
    ssh                  # SSH接続の補完
    zsh-autosuggestions  # コマンド入力時に履歴から候補を表示（要別途インストール）
)

source $ZSH/oh-my-zsh.sh

################
# エディタ     #
################

export EDITOR='vim'

################
# Homebrew     #
################

eval "$(/opt/homebrew/bin/brew shellenv)"

# coreutils, findutils, moreutils
# GNU版コマンドをデフォルトで使用する
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix findutils)/libexec/gnubin:$PATH"
export PATH="$(brew --prefix moreutils)/libexec/bin:$PATH"
export MANPATH="$(brew --prefix coreutils)/libexec/gnuman:$MANPATH"
export MANPATH="$(brew --prefix findutils)/libexec/gnuman:$MANPATH"
export MANPATH="$(brew --prefix moreutils)/libexec/man:$MANPATH"

################
# GPG          #
################

# GPG署名のためにTTYを設定
export GPG_TTY=$(tty)

################
# VOLTA        #
################

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

################
# Claude Code  #
################

export ENABLE_TOOL_SEARCH=true
export CLAUDE_CODE_SYNTAX_HIGHLIGHT=off

# Claude Codeをtmuxセッション内で起動するラッパー関数
# カレントディレクトリ名を元にユニークなセッション名を作成する
function cc() {
    local session_name="claude-$(basename "$PWD" | sed 's/\./-/g')"
    tmux new-session -A -s "$session_name" "claude -c"
}

################
# yazi         #
################

# yaziで移動先のディレクトリに自動的にcdするラッパー関数
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    command yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd < "$tmp"
    [ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

################
# Rancher      #
################

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="$HOME/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

################
# ローカル設定 #
################

# マシン固有の設定は ~/.zshrc.local に記述する
# 例: 会社のプロキシ設定、証明書パスなど
if [[ -f ~/.zshrc.local ]]; then
    source ~/.zshrc.local
fi
