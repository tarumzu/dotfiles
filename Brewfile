# シェル
brew "zsh"
brew "sheldon"      # zsh プラグインマネージャ
brew "starship"     # クロスシェルプロンプト

# エディタ
brew "neovim"
brew "stylua"       # Lua フォーマッタ (nvim conform)
brew "shfmt"        # シェルフォーマッタ (nvim conform)

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
brew "atuin"        # 暗号化シェル履歴同期 (Ctrl-R を置換、.config/atuin/config.toml)

# ターミナル
tap "manaflow-ai/cmux"
cask "cmux"

# フォント (Nerd Font: nvim devicons / starship アイコン用。ghostty と揃える)
cask "font-jetbrains-mono-nerd-font"

# Android 開発
# Toolbox 導入済みだと brew が "App already exists" で失敗するため未導入時のみ
cask "jetbrains-toolbox" unless File.exist?("/Applications/JetBrains Toolbox.app")

# Android CLI (エージェント向け。https://developer.android.com/tools/agents/android-cli)
# formula ではなく cask 配布な点に注意
tap "android/tap"
cask "android-cli"
