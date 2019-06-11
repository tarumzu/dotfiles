#!/bin/sh
echo "-------Start!-------"

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
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew doctor
else
  brew update
fi

# 隠しファイル表示
if defaults read com.apple.finder AppleShowAllFiles | grep -iqE '^(0|off|false|no)$'; then
  defaults write com.apple.finder AppleShowAllFiles TRUE
  killall Finder
fi

# neovim install(起動時に関連プラグイン一括インストール)
which -s /usr/local/bin/nvim
if [[ $? != 0 ]] ; then
  brew install python3
  brew install neovim
  pip3 install neovim
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
fi
brew install zplug
brew install peco

# 通知
brew install terminal-notifier

echo "-------Complete!-------"
echo "Please restart the terminal!"
