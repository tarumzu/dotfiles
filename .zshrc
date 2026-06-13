# -------------------------------------
# Homebrew
# -------------------------------------
if [[ -d '/opt/homebrew' ]]; then
 # Apple Silicon Mac
 HOMEBREW_HOME='/opt/homebrew'
else
 # Intel Mac
 HOMEBREW_HOME='/usr/local'
fi
export PATH="$HOMEBREW_HOME/bin:$HOMEBREW_HOME/sbin:$PATH"
export LANG=ja_JP.UTF-8
export XDG_CONFIG_HOME=$HOME/.config

# Homebrew zsh の fpath はリビジョン差でずれ compinit を見失うため明示追加
if [[ -d "$HOMEBREW_HOME/share/zsh/functions" ]]; then
  fpath=("$HOMEBREW_HOME/share/zsh/functions" $fpath)
fi

# -------------------------------------
# asdf
# -------------------------------------
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

# -------------------------------------
# 補完初期化 (zplug が担っていた compinit を明示実行)
# -------------------------------------
# dump が 24h 超古い時だけフル compinit、それ以外は -C で高速化
# (glob N.mh+24 で判定。[[ -n ...(#q) ]] は [[ ]] 内で glob 展開されず不可)
autoload -Uz compinit
_zcompdump_stale=(${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24))
if (( ${#_zcompdump_stale} )); then
  compinit
else
  compinit -C
fi
unset _zcompdump_stale

# -------------------------------------
# sheldon (プラグインマネージャ)
# プラグイン定義は ~/.config/sheldon/plugins.toml
# -------------------------------------
if command -v sheldon > /dev/null; then
  eval "$(sheldon source)"
fi

# -------------------------------------
# 設定モジュール (~/.zsh/*.zsh)
# -------------------------------------
for conf in options aliases tools keybinds prompt; do
  source ~/.zsh/$conf.zsh
done

# -------------------------------------
# Profile-local 設定 (host 固有 / overlay 由来、gitignored)
# -------------------------------------
[ -f ~/.zsh/local.zsh ] && source ~/.zsh/local.zsh
