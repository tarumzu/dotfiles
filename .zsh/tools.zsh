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
# man を nvim の :Man! で開く (syntax highlight / 折返し / `/` 検索が効く)
export MANPAGER='nvim +Man!'

# bat の light テーマ (Ghostty の TokyoNight Day に合わせる)
if command -v bat > /dev/null; then
  export BAT_THEME=OneHalfLight
fi

# direnv
if command -v direnv > /dev/null; then
  eval "$(direnv hook zsh)"
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

# atuin: 暗号化シェル履歴 (Ctrl-R を置換)
# 設定: ~/.config/atuin/config.toml (CONFIG_LINKS で symlink)
# `↑` は zsh-history-substring-search に残すため --disable-up-arrow
# fzf より後に init して Ctrl-R を atuin に上書きする
if command -v atuin > /dev/null; then
  eval "$(atuin init zsh --disable-up-arrow)"
fi
