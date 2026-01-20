#!/bin/bash

# macOS デフォルト設定
# 使い方: ./macOS/defaults.sh
# 注意: 一部の設定はログアウトまたは再起動後に反映されます

set -eux

# 設定が上書きされないようにシステム環境設定を閉じる
osascript -e 'tell application "System Preferences" to quit'

################
# 一般的なUI   #
################

# 起動時のサウンドを無効化
sudo nvram SystemAudioVolume=" "

# 保存パネルをデフォルトで展開
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# 印刷パネルをデフォルトで展開
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# デフォルトの保存先をiCloudではなくディスクにする
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# 自動大文字変換を無効化
# 文頭を自動で大文字にする機能をオフにする
# コード入力時に意図しない大文字化を防ぐ
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# スマートダッシュを無効化
# "--" が "—"（emダッシュ）に自動変換されるのを防ぐ
# プログラミングやMarkdown記述時に必須
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# 自動ピリオド挿入を無効化
# スペースを2回連続で押すとピリオドが入力される機能をオフにする
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# スマートクォートを無効化
# '"' が '"' や '"' に自動変換されるのを防ぐ
# プログラミングでは直線的なクォートが必須
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# 自動スペル修正を無効化
# 英単語の自動修正をオフにする
# 技術用語やコマンドが勝手に変更されるのを防ぐ
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

################
# キーボード   #
################

# すべてのコントロールでフルキーボードアクセスを有効化（ダイアログでTabキーが使える）
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# キーリピートを高速化
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# 長押しでの特殊文字入力を無効化し、キーリピートを優先
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

################
# トラックパッド #
################

# タップでクリックを有効化
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# 3本指ドラッグを有効化
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

##########
# Finder #
##########

# 隠しファイルを表示
defaults write com.apple.finder AppleShowAllFiles -bool true

# すべてのファイル拡張子を表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# ステータスバーを表示
defaults write com.apple.finder ShowStatusBar -bool true

# パスバーを表示
defaults write com.apple.finder ShowPathbar -bool true

# Finderウィンドウのタイトルにフルパスを表示
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# 名前順でソート時にフォルダを上部に表示
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# 検索時にデフォルトで現在のフォルダ内を検索
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# 拡張子変更時の警告を無効化
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# ネットワークボリュームとUSBボリュームに.DS_Storeファイルを作成しない
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Finderのデフォルト表示をリスト表示にする
# 表示モードコード: `icnv`(アイコン), `clmv`(カラム), `glyv`(ギャラリー), `Nlsv`(リスト)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# ~/Libraryフォルダを表示
chflags nohidden ~/Library

########
# Dock #
########

# Dockアイコンのサイズを設定
defaults write com.apple.dock tilesize -int 48

# 拡大機能を有効化
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 64

# ウィンドウをアプリケーションアイコンに最小化
defaults write com.apple.dock minimize-to-application -bool true

# すべてのDockアイテムでスプリングローディングを有効化
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# 起動中のアプリケーションにインジケータを表示
defaults write com.apple.dock show-process-indicators -bool true

# Dockからアプリケーションを開くときのアニメーションを無効化
defaults write com.apple.dock launchanim -bool false

# Mission Controlのアニメーションを高速化
defaults write com.apple.dock expose-animation-duration -float 0.1

# 最近使用した順にSpacesを自動的に並び替えない
defaults write com.apple.dock mru-spaces -bool false

# Dockを自動的に隠す
defaults write com.apple.dock autohide -bool true

# Dock自動非表示の遅延を削除
defaults write com.apple.dock autohide-delay -float 0

# Dock表示/非表示のアニメーションを削除
defaults write com.apple.dock autohide-time-modifier -float 0

# 最近使用したアプリケーションをDockに表示しない
defaults write com.apple.dock show-recents -bool false

##################
# スクリーンショット #
##################

# スクリーンショットをファイルではなくクリップボードに保存
defaults write com.apple.screencapture target -string "clipboard"

# スクリーンショットをPNG形式で保存（Ctrlキーでファイル保存時に使用）
defaults write com.apple.screencapture type -string "png"

# スクリーンショットの影を無効化
defaults write com.apple.screencapture disable-shadow -bool true

############
# TextEdit #
############

# 新規TextEditドキュメントをプレーンテキストモードで開く
defaults write com.apple.TextEdit RichText -int 0

# TextEditでUTF-8エンコーディングを使用
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

########################
# アクティビティモニタ #
########################

# アクティビティモニタ起動時にメインウィンドウを表示
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# DockアイコンにCPU使用率を表示
defaults write com.apple.ActivityMonitor IconType -int 5

# すべてのプロセスを表示
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# CPU使用率でソート
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

########################
# アプリケーションの再起動 #
########################

for app in "Activity Monitor" \
  "Dock" \
  "Finder" \
  "SystemUIServer"; do
  killall "${app}" &> /dev/null || true
done

echo "完了しました。一部の設定はログアウトまたは再起動後に反映されます。"
