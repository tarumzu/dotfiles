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
brew "gh"           # GitHub CLI (PR / issue / workflow 操作)
brew "asdf"         # 言語バージョン管理 (.zshrc / tools.zsh の JAVA_HOME helper が前提)
brew "bat"          # cat の代替 (syntax highlight, paging)
brew "eza"          # ls の代替 (git-aware, icons)
brew "git-delta"    # git diff の見た目改善 (.gitconfig で pager に紐付け)
brew "jq"           # JSON プロセッサ

# ターミナル
tap "manaflow-ai/cmux"
cask "cmux"

# Android 開発
# 公式インストーラ等で既に Toolbox が入っている場合は brew install が
# "App already exists" で失敗するため、未インストール時のみ brew に任せる。
cask "jetbrains-toolbox" unless File.exist?("/Applications/JetBrains Toolbox.app")

# Android CLI (https://developer.android.com/tools/agents/android-cli)
# Android Studio / SDK / Journeys 等を操作するエージェント向け CLI。
# android/homebrew-tap は formula ではなく cask として配布している点に注意。
tap "android/tap"
cask "android-cli"
