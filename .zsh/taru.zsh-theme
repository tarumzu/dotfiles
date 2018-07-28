# -------------------------------------
# zshのオプション
# -------------------------------------
unsetopt auto_menu # タブによるファイルの順番切り替えをしない
setopt correct # 入力しているコマンド名が間違っている場合にもしかして：を出す
setopt nobeep # ビープを鳴らさない
setopt ignoreeof # ^Dでログアウトしない
setopt no_tify # バックグラウンドジョブが終了したらすぐに知らせる
setopt hist_ignore_dups  # 直前と同じコマンドをヒストリに追加しない
setopt complete_in_word  # カーソル位置で補完する。
setopt auto_pushd # cd -[tab]で過去のディレクトリにひとっ飛びできるようにする
setopt INTERACTIVE_COMMENTS # コマンドラインでも # 以降をコメントと見なす
setopt COMPLETE_IN_WORD # 語の途中でもカーソル位置で補完
export HISTFILE=${HOME}/.zsh_history # 履歴ファイルの保存先
export HISTSIZE=2000 # メモリに保存される履歴の件数
export SAVEHIST=100000 # 履歴ファイルに保存される履歴の件数
setopt hist_ignore_dups # 重複を記録しない
setopt share_history # history共有
setopt EXTENDED_HISTORY # 開始と終了を記録
setopt hist_ignore_all_dups # ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_verify # ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_no_store # historyコマンドは履歴に登録しない
setopt INC_APPEND_HISTORY # 履歴をインクリメンタルに追加

#履歴のインクリメンタル検索でワイルドカード利用可能
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
#入力途中の履歴補完を有効化する
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# -------------------------------------
# パス
# -------------------------------------
# 重複する要素を自動的に削除
typeset -U path cdpath fpath manpath

path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)

# -------------------------------------
# プロンプト
# -------------------------------------

### 補完機能の強化
autoload -U promptinit; promptinit
autoload -Uz colors; colors
autoload -Uz vcs_info
autoload -Uz is-at-least

ok="* '-'）"
ng="*｀д´）"
p_prompt="
%(?.%{$fg[green]%}.%{$fg[red]%})%(?!$ok!$ng)%{${reset_color}%} "
prompt_tag "$p_prompt"

RPROMPT="[%*]"

# -------------------------------------
# エイリアス
# -------------------------------------

# -n 行数表示, -I バイナリファイル無視, svn関係のファイルを無視
alias grep="grep --color -n -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"

# ls
alias ls="ls -G" # color for darwin
alias l="ls -la"
alias la="ls -la"
alias l1="ls -1"

# tree
alias tree="tree -NC" # N: 文字化け対策, C:色をつける


# -------------------------------------
# キーバインド
# -------------------------------------

bindkey -e

function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey '^K' cdup

bindkey "^R" history-incremental-search-backward

# -------------------------------------
# その他
# -------------------------------------

# cdしたあとで、自動的に ls する
function chpwd() { ls }
