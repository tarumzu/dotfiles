# -------------------------------------
# zsh のオプション
# -------------------------------------
unsetopt auto_menu          # タブによるファイルの順番切り替えをしない
setopt correct              # コマンド名が間違っている場合に「もしかして」を出す
setopt nobeep               # ビープを鳴らさない
setopt ignoreeof            # ^D でログアウトしない
setopt notify               # バックグラウンドジョブが終了したらすぐに知らせる
setopt complete_in_word     # カーソル位置で補完する
setopt auto_pushd           # cd -[tab] で過去のディレクトリに飛べる
setopt interactive_comments # コマンドラインでも # 以降をコメントと見なす

# -------------------------------------
# ヒストリ
# -------------------------------------
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=2000         # メモリに保存される件数
export SAVEHIST=100000       # ファイルに保存される件数
setopt hist_ignore_all_dups  # 重複する古いコマンドを削除して記録
setopt share_history         # 履歴をプロセス間で共有
setopt extended_history      # 開始と終了を記録
setopt hist_verify           # 履歴呼び出し後、実行前に一旦編集可能
setopt hist_no_store         # history コマンド自体は履歴に登録しない
setopt inc_append_history    # 履歴をインクリメンタルに追加

# -------------------------------------
# パス
# -------------------------------------
typeset -U path cdpath fpath manpath  # 重複要素を自動的に削除
path=(
    $HOME/bin(N-/)
    /usr/local/bin(N-/)
    /usr/local/sbin(N-/)
    $path
)
