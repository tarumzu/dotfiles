#!/bin/bash
set -euo pipefail
echo "-------Start!-------"

# 隠しファイル表示
defaults write com.apple.finder AppleShowAllFiles YES
killall Finder

# keyのリピート速度Max ※ Macの再起動が必要
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# gitconfig設定値のデフォルト取得
gitname=$(git config user.name || true)
gitemail=$(git config user.email || true)

# dotfilesコピー
mkdir -p "${HOME}/.config"
readonly DOT_FILES=(
                    .vimrc
                    .zshrc .zsh
                    .commit_template .gitconfig
                   )
for file in "${DOT_FILES[@]}"; do
  ln -fs "${PWD}/${file}" "${HOME}/${file}"
done
# ~/.config 配下の symlink (実体ディレクトリなら退避してから張り替え)
readonly CONFIG_LINKS=(
                       nvim          # Neovim (lazy.nvim, lazy-lock.json もリポジトリ管理)
                       sheldon       # zsh プラグイン定義
                       starship.toml # プロンプト設定
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

# Attention! 先にxcodeインストールすること
# コマンドラインツール
if ! xcode-select -p &>/dev/null; then
  xcode-select --install
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

# Neovim の Python プロバイダ (macOS の Homebrew Python は PEP 668 で守られているため明示的に許可)
pip3 install --break-system-packages pynvim

# /etc/shells と default shell を必要な時だけ更新
if ! grep -qxF "$HOMEBREW_HOME/bin/zsh" /etc/shells; then
  echo "$HOMEBREW_HOME/bin/zsh" | sudo tee -a /etc/shells
fi
if [ "${SHELL:-}" != "$HOMEBREW_HOME/bin/zsh" ]; then
  chsh -s "$HOMEBREW_HOME/bin/zsh"
fi

echo "-------Complete!-------"
echo "Please restart your Mac!"
