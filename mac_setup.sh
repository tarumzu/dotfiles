#!/bin/bash
set -euo pipefail
echo "-------Start!-------"

# repo root を解決 (${PWD} 依存だと任意 CWD 実行で symlink が壊れるため)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -y / --yes: git identity の対話入力をスキップ (再実行・無人実行向け)
assume_yes=0
for arg in "$@"; do
  case "$arg" in
    -y|--yes) assume_yes=1 ;;
    *) echo "unknown option: $arg (usage: $0 [-y|--yes])" >&2; exit 2 ;;
  esac
done

# Mac の再起動が必要な変更があったかを追跡する
needs_restart=0

# Xcode CLT を git/brew より先に導入 (未導入なら GUI を出して完了まで待つ)
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  echo "Waiting for Xcode Command Line Tools to finish installing..."
  until xcode-select -p &>/dev/null; do
    sleep 10
  done
fi

# Finder 関連の defaults をまとめて反映 (どれか変更したら最後に Finder を再起動)
_finder_dirty=0

# 隠しファイル表示
_v=$(defaults read com.apple.finder AppleShowAllFiles 2>/dev/null || true)
if [ "$_v" != "YES" ] && [ "$_v" != "1" ]; then
  defaults write com.apple.finder AppleShowAllFiles -bool true
  _finder_dirty=1
fi

# パスバー / ステータスバー
if [ "$(defaults read com.apple.finder ShowPathbar 2>/dev/null || true)" != "1" ]; then
  defaults write com.apple.finder ShowPathbar -bool true
  _finder_dirty=1
fi
if [ "$(defaults read com.apple.finder ShowStatusBar 2>/dev/null || true)" != "1" ]; then
  defaults write com.apple.finder ShowStatusBar -bool true
  _finder_dirty=1
fi

# 拡張子を常に表示 (グローバルキーだが Finder が参照する)
if [ "$(defaults read -g AppleShowAllExtensions 2>/dev/null || true)" != "1" ]; then
  defaults write -g AppleShowAllExtensions -bool true
  _finder_dirty=1
fi

if [ "$_finder_dirty" -eq 1 ]; then
  killall Finder 2>/dev/null || true
fi
unset _finder_dirty _v

# キーリピート速度Max ※ 反映には Mac の再起動が必要 (差分があるときだけ書く)
if [ "$(defaults read -g InitialKeyRepeat 2>/dev/null || true)" != "15" ]; then
  defaults write -g InitialKeyRepeat -int 15
  needs_restart=1
fi
if [ "$(defaults read -g KeyRepeat 2>/dev/null || true)" != "2" ]; then
  defaults write -g KeyRepeat -int 2
  needs_restart=1
fi

# 長押しで accent menu ではなくキーリピートを発火 (Vim/IDE のキャレット移動に必須)
if [ "$(defaults read -g ApplePressAndHoldEnabled 2>/dev/null || true)" != "0" ]; then
  defaults write -g ApplePressAndHoldEnabled -bool false
  needs_restart=1
fi

# テキスト入力の自動修正 / 先頭大文字化を停止 (コマンドやコード入力で誤書換を防止)
if [ "$(defaults read -g NSAutomaticSpellingCorrectionEnabled 2>/dev/null || true)" != "0" ]; then
  defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
fi
if [ "$(defaults read -g NSAutomaticCapitalizationEnabled 2>/dev/null || true)" != "0" ]; then
  defaults write -g NSAutomaticCapitalizationEnabled -bool false
fi

# dotfilesコピー
mkdir -p "${HOME}/.config"
readonly DOT_FILES=(
                    .zshrc .zsh
                    .commit_template .gitconfig
                   )
# -n: ~/.zsh 等が既に symlink dir の時、配下への再帰 symlink を防ぐ
for file in "${DOT_FILES[@]}"; do
  ln -nfs "${SCRIPT_DIR}/${file}" "${HOME}/${file}"
done
# ~/.config 配下の symlink (実体ディレクトリなら退避してから張り替え)
readonly CONFIG_LINKS=(
                       nvim          # Neovim (lazy.nvim, lazy-lock.json もリポジトリ管理)
                       sheldon       # zsh プラグイン定義
                       starship.toml # プロンプト設定
                       ghostty       # Ghostty 設定 (XDG_CONFIG_HOME 配下を参照)
                       git           # global gitignore (XDG: ~/.config/git/ignore)
                       atuin         # atuin config.toml (encrypted history sync)
                      )
for path in "${CONFIG_LINKS[@]}"; do
  if [ -e "${HOME}/.config/${path}" ] && [ ! -L "${HOME}/.config/${path}" ]; then
    mv "${HOME}/.config/${path}" "${HOME}/.config/${path}_$(date "+%Y%m%d_%H%M%S")"
  fi
  ln -nfs "${SCRIPT_DIR}/.config/${path}" "${HOME}/.config/${path}"
done

# git identity を ~/.gitconfig_user に書く (既存値を default に引き継ぐ)
gitname=$(git config -f "${HOME}/.gitconfig_user" user.name 2>/dev/null || true)
gitemail=$(git config -f "${HOME}/.gitconfig_user" user.email 2>/dev/null || true)
[ -z "$gitname" ]  && gitname=$(git config user.name 2>/dev/null || true)
[ -z "$gitemail" ] && gitemail=$(git config user.email 2>/dev/null || true)

if [ "$assume_yes" -eq 1 ]; then
  # -y: prompt せず現在値を使う (未設定なら警告のみ)
  [ -z "$gitname" ]  && echo "warn: git user.name is unset; set it in ~/.gitconfig_user later." >&2
  [ -z "$gitemail" ] && echo "warn: git user.email is unset; set it in ~/.gitconfig_user later." >&2
else
  read -r -p "gitconfig user.name (${gitname}):" name
  [ -n "$name" ] && gitname=$name
  read -r -p "gitconfig user.email (${gitemail}):" email
  [ -n "$email" ] && gitemail=$email
fi

# 空値で上書きしない (-y かつ未設定時に "" を書かないため)
[ -n "$gitname" ]  && git config -f "${HOME}/.gitconfig_user" user.name "$gitname"
[ -n "$gitemail" ] && git config -f "${HOME}/.gitconfig_user" user.email "$gitemail"

# brew install
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # インストール直後は PATH 未通なので明示ロード
  if [[ -d '/opt/homebrew' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  brew doctor || true
else
  brew update
fi

if [[ -d '/opt/homebrew' ]]; then
 # apple silicon Mac
 HOMEBREW_HOME='/opt/homebrew'
else
 # Intel Mac
 HOMEBREW_HOME='/usr/local'
fi

export PATH="$HOMEBREW_HOME/bin:$HOMEBREW_HOME/sbin:$PATH"

# Brewfile に定義したパッケージを一括インストール
brew bundle --file="${SCRIPT_DIR}/Brewfile"

# overlay: DOTFILES_OVERLAY=<git URL> を ~/.dotfiles-overlay に clone し
# Brewfile.local / zsh/local.zsh を取り込む (未指定なら no-op)
OVERLAY_DIR="${DOTFILES_OVERLAY_DIR:-${HOME}/.dotfiles-overlay}"
if [ -n "${DOTFILES_OVERLAY:-}" ]; then
  if [ ! -d "$OVERLAY_DIR/.git" ]; then
    git clone "$DOTFILES_OVERLAY" "$OVERLAY_DIR"
  else
    git -C "$OVERLAY_DIR" pull --ff-only 2>/dev/null || true
  fi
fi
if [ -d "$OVERLAY_DIR/.git" ]; then
  [ -f "$OVERLAY_DIR/Brewfile.local" ] && \
    ln -nfs "$OVERLAY_DIR/Brewfile.local" "${SCRIPT_DIR}/Brewfile.local"
  [ -f "$OVERLAY_DIR/zsh/local.zsh" ] && \
    ln -nfs "$OVERLAY_DIR/zsh/local.zsh" "${HOME}/.zsh/local.zsh"
fi
# Brewfile.local (overlay 由来 or 手書き) があれば追加インストール
if [ -f "${SCRIPT_DIR}/Brewfile.local" ]; then
  brew bundle --file="${SCRIPT_DIR}/Brewfile.local"
fi
# overlay 独自の setup.sh があれば実行 (SSH/git 署名等は overlay 側、idempotent 前提)
if [ -x "$OVERLAY_DIR/setup.sh" ]; then
  "$OVERLAY_DIR/setup.sh"
fi

# /etc/shells と default shell を必要な時だけ更新
if ! grep -qxF "$HOMEBREW_HOME/bin/zsh" /etc/shells; then
  echo "$HOMEBREW_HOME/bin/zsh" | sudo tee -a /etc/shells
fi
# ログインシェルは dscl で判定 ($SHELL は再ログインまで古く、再実行で chsh 空打ちを招く)
_current_shell="$(dscl . -read "$HOME" UserShell 2>/dev/null | awk '{print $2}')"
if [ "$_current_shell" != "$HOMEBREW_HOME/bin/zsh" ]; then
  chsh -s "$HOMEBREW_HOME/bin/zsh"
fi
unset _current_shell

echo "-------Complete!-------"
if [ "$needs_restart" -eq 1 ]; then
  echo "Please restart your Mac to apply input settings."
fi

# GitHub CLI が未認証なら警告 (PR / issue 操作で都度詰まらないように初回 setup 時に気づける)
if command -v gh > /dev/null && ! gh auth status &>/dev/null; then
  echo "gh: not authenticated — run \`gh auth login\` when ready."
fi
