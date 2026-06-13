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

# Homebrew zsh はコンパイル時 fpath がバージョン付き Cellar パス
# (例: .../zsh/5.9/...) を指すが、リビジョン (5.9.1 等) ではディレクトリ名が
# 食い違い compinit/promptinit が見つからなくなる。リンク先を明示追加して回避。
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
# .zcompdump が 24h より古い (= 要再生成) の時だけフルの compinit
# (セキュリティチェック込み) を走らせ、それ以外は -C でチェックを省いて
# 起動を高速化する。glob 修飾子 (N.mh+24) で「24h 超前に変更された
# 通常ファイル」を配列に集め、空かどうかで分岐する。
# ※ [[ -n ...(#q...) ]] 形式は [[ ]] 内で filename generation が起きず
#   常に真になるため使わない。
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
