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

# エディタ
export EDITOR=nvim

# direnv
if command -v direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi

# Go
if command -v go > /dev/null; then
  export GOPATH=$HOME/.go
  export PATH=$PATH:$GOPATH/bin
fi

# fzf
export FZF_COMPLETION_TRIGGER='~~'   # 既定の ** ではなく ~~ を使う
export FZF_COMPLETION_OPTS='+c -x'
# 候補列挙に find ではなく fd を使う
if command -v fd > /dev/null; then
  _fzf_compgen_path() {
    fd --hidden --follow --exclude .git . "$1"
  }
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude .git . "$1"
  }
fi
# fzf シェル統合 (fzf >= 0.48)
if command -v fzf > /dev/null; then
  eval "$(fzf --zsh)"
fi
