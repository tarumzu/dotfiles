#!/bin/sh
echo "-------Start!-------"

# 隠しファイル表示
if defaults read com.apple.finder AppleShowAllFiles | grep -iqE '^(0|off|false|no)$'; then
  defaults write com.apple.finder AppleShowAllFiles TRUE
  killall Finder
fi

# keyのリピート速度Max ※ Macの再起動が必要
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

# gitconfig設定値のデフォルト取得
gitname=$(git config user.name)
gitemail=$(git config user.email)

# dotfilesコピー
mkdir -p ${HOME}/.config/nvim
readonly DOT_FILES=( 
                    .vimrc
                    .config/nvim/dein.toml .config/nvim/dein_lazy.toml
                    .zshrc .zsh
                    .commit_template .gitconfig
                   )
for file in ${DOT_FILES[@]}; do
  ln -fs ${PWD}/${file} ${HOME}/${file}
done
# nvim設定
if [ ! -L ${HOME}/.config/nvim/userautoload ]; then
  mv ${HOME}/.config/nvim/userautoload ${HOME}/.config/nvim/userautoload_`date "+%Y%m%d_%H%M%S"`
fi
ln -nfs ${PWD}/.config/nvim/userautoload ${HOME}/.config/nvim/userautoload
ln -fs ${HOME}/.vimrc ${HOME}/.config/nvim/init.vim

# gitconfig設定
read -p "gitconfig user.name ($gitname):" name
if [ -n "$name" ]; then
  gitname=$name
fi
git config --global user.name "$gitname"
read -p "gitconfig user.email ($gitemail):" email
if [ -n "$email" ]; then
  gitemail=$email
fi
git config --global user.email "$gitemail"

# Attention! 先にxcodeインストールすること
# コマンドラインツール
if [ ! -d "$(xcode-select -p)" ]; then
  xcode-select --install
fi

# brew install
which -s brew
if [[ $? != 0 ]] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew doctor
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
which -s $HOMEBREW_HOME/bin/zsh
if [[ $? != 0 ]] ; then
  $HOMEBREW_HOME/bin/brew install zsh
  # change default shell
  echo $HOMEBREW_HOME/bin/zsh | sudo tee -a /etc/shells
fi
chsh -s $HOMEBREW_HOME/bin/zsh

# neovim install(起動時に関連プラグイン一括インストール)
which -s $HOMEBREW_HOME/bin/nvim
if [[ $? != 0 ]] ; then
  brew install python3
  brew install neovim
  pip3 install neovim
fi

# ruby install
brew install rbenv

brew install zplug
brew install peco

# 通知
brew install terminal-notifier

echo "-------Complete!-------"
echo "Please restart your Mac!"
