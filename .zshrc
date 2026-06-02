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
# zplug
# -------------------------------------
export ZPLUG_HOME=$HOMEBREW_HOME/opt/zplug
source $ZPLUG_HOME/init.zsh

## syntax
zplug "chrissicool/zsh-256color"
zplug "Tarrasch/zsh-colors"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "ascii-soup/zsh-url-highlighter"

## prompt
zplug "nojhan/liquidprompt"

## tools
zplug "marzocchi/zsh-notify"                    # 処理終了時に mac へ通知
zplug "zsh-users/zsh-history-substring-search"  # 履歴強化
zplug "wbinglee/zsh-wakatime"                   # コマンド実行時間表示
zplug "b4b4r07/enhancd", use:enhancd.sh

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load --verbose

# -------------------------------------
# 設定モジュール (~/.zsh/*.zsh)
# -------------------------------------
for conf in options aliases tools keybinds prompt; do
  source ~/.zsh/$conf.zsh
done
