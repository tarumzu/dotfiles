# enhancd
export ENHANCD_FILTER=fzf

# Android
export PATH=$PATH:$HOME/Library/Android/sdk/platform-tools  # adb
# Android Studio (JetBrains Toolbox) の JDK を JAVA_HOME に (未インストールなら静かにスキップ)
_as_toolbox="$HOME/Library/Application Support/JetBrains/Toolbox/apps/AndroidStudio/ch-0"
if [ -d "$_as_toolbox" ]; then
  export JAVA_HOME=$(find "$_as_toolbox" -path '*/Android Studio*.app/Contents/jbr/Contents/Home' | head -n 1)
fi
unset _as_toolbox

# direnv
if which direnv > /dev/null; then
  export EDITOR=vim
  eval "$(direnv hook zsh)"
fi

# Go
if which go > /dev/null; then
  export GOPATH=$HOME/.go
  export PATH=$PATH:$GOPATH/bin
fi

# fzf
export FZF_COMPLETION_TRIGGER='~~'   # 既定の ** ではなく ~~ を使う
export FZF_COMPLETION_OPTS='+c -x'
# 候補列挙に find ではなく ag を使う
_fzf_compgen_path() {
  ag -g "" "$1"
}
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
