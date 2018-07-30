#!/bin/sh

# Attention! 先にxcodeインストールすること
# コマンドラインツール
xcode-select --install

# brew install
which -s brew
if [[ $? != 0 ]] ; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew doctor
else
  brew update
fi

# 隠しファイル表示
defaults write com.apple.finder AppleShowAllFiles TRUE
killall Finder

# neovim install(起動時に関連プラグイン一括インストール)
which -s /usr/local/bin/nvim
if [[ $? != 0 ]] ; then
  brew install neovim
  cp -rf ./.config ./.vimrc ~/
  ln -s ~/.vimrc ~/.config/nvim/init.vim
fi

# ruby install
brew install rbenv

# zsh install
which -s /usr/local/bin/zsh
if [[ $? != 0 ]] ; then
  brew install zsh
  # change default shell
  echo /usr/local/bin/zsh | sudo tee -a /etc/shells
  chsh -s /usr/local/bin/zsh
  cp -rf ./.zsh ./.zshrc ~/
fi
brew install zplug
brew install peco
