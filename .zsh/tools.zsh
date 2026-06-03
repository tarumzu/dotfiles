# enhancd
export ENHANCD_FILTER=fzf

# Android SDK (Android Studio のデフォルト配置: ~/Library/Android/sdk)
# 未インストール時は静かにスキップ
if [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  export ANDROID_SDK_ROOT="$ANDROID_HOME"
  for _p in platform-tools cmdline-tools/latest/bin emulator; do
    [ -d "$ANDROID_HOME/$_p" ] && export PATH="$PATH:$ANDROID_HOME/$_p"
  done
  unset _p
fi

# JAVA_HOME を asdf-java で動的に追従 (asdf plugin add java 済みの場合のみ)
_asdf_java_helper="${ASDF_DATA_DIR:-$HOME/.asdf}/plugins/java/set-java-home.zsh"
if [ -f "$_asdf_java_helper" ]; then
  . "$_asdf_java_helper"
fi
unset _asdf_java_helper

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
