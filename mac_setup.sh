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
mkdir -p "${HOME}/.config/nvim"
readonly DOT_FILES=(
                    .vimrc
                    .config/nvim/dein.toml .config/nvim/dein_lazy.toml
                    .zshrc .zsh
                    .commit_template .gitconfig
                   )
for file in "${DOT_FILES[@]}"; do
  ln -fs "${PWD}/${file}" "${HOME}/${file}"
done
# nvim設定
if [ -e "${HOME}/.config/nvim/userautoload" ] && [ ! -L "${HOME}/.config/nvim/userautoload" ]; then
  mv "${HOME}/.config/nvim/userautoload" "${HOME}/.config/nvim/userautoload_$(date "+%Y%m%d_%H%M%S")"
fi
ln -nfs "${PWD}/.config/nvim/userautoload" "${HOME}/.config/nvim/userautoload"
ln -fs "${HOME}/.vimrc" "${HOME}/.config/nvim/init.vim"

# gitconfig設定 (リポジトリ管理外の ~/.gitconfig_user に書き込む)
read -p "gitconfig user.name (${gitname}):" name
if [ -n "$name" ]; then
  gitname=$name
fi
git config -f "${HOME}/.gitconfig_user" user.name "$gitname"
read -p "gitconfig user.email (${gitemail}):" email
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

# zsh install
if [ ! -x "$HOMEBREW_HOME/bin/zsh" ]; then
  brew install zsh
fi
# /etc/shells と default shell を必要な時だけ更新
if ! grep -qxF "$HOMEBREW_HOME/bin/zsh" /etc/shells; then
  echo "$HOMEBREW_HOME/bin/zsh" | sudo tee -a /etc/shells
fi
if [ "${SHELL:-}" != "$HOMEBREW_HOME/bin/zsh" ]; then
  chsh -s "$HOMEBREW_HOME/bin/zsh"
fi

# neovim install(起動時に関連プラグイン一括インストール)
if [ ! -x "$HOMEBREW_HOME/bin/nvim" ]; then
  brew install neovim
  # macOS の Homebrew Python は PEP 668 で守られているため明示的に許可
  pip3 install --break-system-packages pynvim
fi

brew install zplug
brew install peco

# 通知
brew install terminal-notifier

# terminal
brew tap manaflow-ai/cmux
brew install --cask cmux

echo "-------Complete!-------"
echo "Please restart your Mac!"
