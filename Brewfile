# シェル
brew "zsh"
brew "sheldon"      # zsh プラグインマネージャ
brew "starship"     # クロスシェルプロンプト

# エディタ
brew "neovim"

# CLI ツール
brew "ghq"          # リポジトリ管理 (g エイリアス)
brew "fzf"          # ファジーファインダ (履歴 / 補完 / enhancd / g エイリアス)
brew "fd"           # find の代替 (fzf 候補列挙)
brew "ripgrep"      # grep の代替
brew "direnv"       # ディレクトリ単位の環境変数

# 通知
brew "terminal-notifier"

# ターミナル
tap "manaflow-ai/cmux"
cask "cmux"

# Android 開発
# 公式インストーラ等で既に Toolbox が入っている場合は brew install が
# "App already exists" で失敗するため、未インストール時のみ brew に任せる。
cask "jetbrains-toolbox" unless File.exist?("/Applications/JetBrains Toolbox.app")
