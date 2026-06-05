#!/bin/bash
set -euo pipefail
echo "-------Start!-------"

# Mac の再起動が必要な変更があったかを追跡する
needs_restart=0

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

# gitconfig設定値のデフォルト取得
gitname=$(git config user.name || true)
gitemail=$(git config user.email || true)

# dotfilesコピー
mkdir -p "${HOME}/.config"
readonly DOT_FILES=(
                    .zshrc .zsh
                    .commit_template .gitconfig
                   )
# -n が無いと、対象 (~/.zsh など) が既に symlink で directory を指している場合に
# その配下へリンクを作ってしまい再帰 symlink が発生する。
for file in "${DOT_FILES[@]}"; do
  ln -nfs "${PWD}/${file}" "${HOME}/${file}"
done
# ~/.config 配下の symlink (実体ディレクトリなら退避してから張り替え)
readonly CONFIG_LINKS=(
                       nvim          # Neovim (lazy.nvim, lazy-lock.json もリポジトリ管理)
                       sheldon       # zsh プラグイン定義
                       starship.toml # プロンプト設定
                       ghostty       # Ghostty 設定 (XDG_CONFIG_HOME 配下を参照)
                       git           # global gitignore (XDG: ~/.config/git/ignore)
                      )
for path in "${CONFIG_LINKS[@]}"; do
  if [ -e "${HOME}/.config/${path}" ] && [ ! -L "${HOME}/.config/${path}" ]; then
    mv "${HOME}/.config/${path}" "${HOME}/.config/${path}_$(date "+%Y%m%d_%H%M%S")"
  fi
  ln -nfs "${PWD}/.config/${path}" "${HOME}/.config/${path}"
done

# gitconfig設定 (リポジトリ管理外の ~/.gitconfig_user に書き込む)
read -r -p "gitconfig user.name (${gitname}):" name
if [ -n "$name" ]; then
  gitname=$name
fi
git config -f "${HOME}/.gitconfig_user" user.name "$gitname"
read -r -p "gitconfig user.email (${gitemail}):" email
if [ -n "$email" ]; then
  gitemail=$email
fi
git config -f "${HOME}/.gitconfig_user" user.email "$gitemail"

# Xcode Command Line Tools (未導入なら GUI ダイアログを起動し、完了するまで後続を待たせる)
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  echo "Waiting for Xcode Command Line Tools to finish installing..."
  until xcode-select -p &>/dev/null; do
    sleep 10
  done
fi

# brew install
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # インストール直後のセッションには PATH が通っていないので明示的にロード
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
brew bundle --file="${PWD}/Brewfile"

# /etc/shells と default shell を必要な時だけ更新
if ! grep -qxF "$HOMEBREW_HOME/bin/zsh" /etc/shells; then
  echo "$HOMEBREW_HOME/bin/zsh" | sudo tee -a /etc/shells
fi
if [ "${SHELL:-}" != "$HOMEBREW_HOME/bin/zsh" ]; then
  chsh -s "$HOMEBREW_HOME/bin/zsh"
fi

echo "-------Complete!-------"
if [ "$needs_restart" -eq 1 ]; then
  echo "Please restart your Mac to apply input settings."
fi
