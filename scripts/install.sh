#!/bin/bash

# dotfiles インストーラー
# 使い方: ./scripts/install.sh

set -eu

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

echo "dotfiles ディレクトリ: $DOTFILES_DIR"

# OS判定
detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            if grep -q microsoft /proc/version 2>/dev/null; then
                echo "wsl"
            else
                echo "linux"
            fi
            ;;
        MINGW*|MSYS*|CYGWIN*)
            echo "windows"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

OS=$(detect_os)
echo "検出されたOS: $OS"

case "$OS" in
    macos)
        echo "macOS用の初期化スクリプトを実行します..."
        cd "$DOTFILES_DIR"
        bash ./macos/init.sh
        ;;
    wsl)
        echo "WSL2用の初期化スクリプトを実行します..."
        if [[ -f "$DOTFILES_DIR/wsl/init.sh" ]]; then
            cd "$DOTFILES_DIR"
            bash ./wsl/init.sh
        else
            echo "エラー: wsl/init.sh が見つかりません"
            exit 1
        fi
        ;;
    linux)
        echo "Linux用の初期化スクリプトを実行します..."
        if [[ -f "$DOTFILES_DIR/linux/init.sh" ]]; then
            cd "$DOTFILES_DIR"
            bash ./linux/init.sh
        else
            echo "エラー: linux/init.sh が見つかりません"
            exit 1
        fi
        ;;
    windows)
        echo "Windowsでは PowerShell を使用してください:"
        echo "  .\\windows\\init.ps1"
        exit 1
        ;;
    *)
        echo "エラー: サポートされていないOSです"
        exit 1
        ;;
esac

echo "インストールが完了しました！"
