bindkey -e

# ^K: 親ディレクトリへ移動
function cdup() {
   echo
   cd ..
   zle reset-prompt
}
zle -N cdup
bindkey '^K' cdup

# ^R (履歴) / ^T (ファイル) / Alt-C (cd) は fzf シェル統合 (tools.zsh) が提供
