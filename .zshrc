export ZPLUG_HOME=/usr/local/opt/zplug
export LANG=ja_JP.UTF-8
source $ZPLUG_HOME/init.zsh

## syntax
zplug "chrissicool/zsh-256color"
zplug "Tarrasch/zsh-colors"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "ascii-soup/zsh-url-highlighter"

## prompt
zplug "nojhan/liquidprompt"

## tools
zplug "marzocchi/zsh-notify"  # 処理終わったらmacに通知飛ばす
zplug "zsh-users/zsh-history-substring-search" # 履歴強化
zplug "wbinglee/zsh-wakatime"  # コマンドにかかった時間表示
zplug "b4b4r07/enhancd", use:enhancd.sh
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi 
fi 
# プラグインを読み込み、コマンドにパスを通す
zplug load --verbose

source ~/.zsh/taru.zsh-theme

# User configuration
export ENHANCD_FILTER=fzf cd
export PATH=$HOME/bin:/usr/local/bin/:/usr/local/sbin:$PATH
#export PATH="$HOME/.rbenv/shims:$PATH"
export PATH=$PATH:/usr/local/share/python
#export PATH="$HOME/.rbenv/bin:$PATH"



# github用コマンド
#eval "$(hub alias -s)"




 # adb設定
export PATH=$PATH:$HOME/Library/Android/sdk/platform-tools
#export PATH=$HOME/.rbenv:$PATH
export PATH=/usr/local/opt/rbenv/bin:$PATH
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
# docker設定
#eval "$(docker-machine env default)"
# added by travis gem
[ -f /Users/user/.travis/travis.sh ] && source /Users/user/.travis/travis.sh

if [[ -s /Users/mizukami/.nvm/nvm.sh ]] ; then source /Users/mizukami/.nvm/nvm.sh ; fi

# direnv
if which direnv > /dev/null; then
  export EDITOR=vim
  eval "$(direnv hook zsh)"
fi

# nvim
export XDG_CONFIG_HOME=$HOME/.config
alias vim=nvim


# fzf
# Use ~~ as the trigger sequence instead of the default **
export FZF_COMPLETION_TRIGGER='~~'

# Options to fzf command
export FZF_COMPLETION_OPTS='+c -x'
# Use ag instead of the default find command for listing candidates.
# - The first argument to the function is the base path to start traversal
# - Note that ag only lists files not directories
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  ag -g "" "$1"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


export PATH="$HOME/.fastlane/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
##Android SDK
#export PATH=$PATH:~/Library/Android/sdk/platform-tools
#export PATH=$PATH:~/Library/Android/sdk/tools
export ANDROID_HOME=$PATH:~/Library/Android/sdk

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

if which pyenv > /dev/null; then
  export PATH="$HOME/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
fi


# タイトル動的
precmd() {
   pwd=$(pwd)
   cwd=${pwd##*/}
   print -Pn "\e]0;$cwd\a"
}

#preexec() {
#   if overridden; then return; fi
#   printf "\033]0;%s\a" "${1%% *} | $cwd"

## Go 環境設定
if [ -x "`which go`" ]; then
  export GOPATH=$HOME/.go
  export PATH=$PATH:$GOPATH/bin
fi

# peco history整備
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history
