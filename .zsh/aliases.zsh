# grep: -n 行数表示, -I バイナリ無視, svn 関係を無視
alias grep="grep --color -n -I --exclude='*.svn-*' --exclude='entries' --exclude='*/cache/*'"

# ls (eza があれば優先: 色 + git ステータス内蔵。未導入なら darwin の ls にフォールバック)
if command -v eza > /dev/null; then
  alias ls="eza --git"
  alias l="eza -la --git"
  alias la="eza -la --git"
  alias l1="eza -1"
else
  alias ls="ls -G"   # color for darwin
  alias l="ls -la"
  alias la="ls -la"
  alias l1="ls -1"
fi

# tree: -N 文字化け対策, -C 色付け
alias tree="tree -NC"

# nvim
alias vim=nvim

# ghq + fzf: リポジトリを選択して cd
alias g='cd $(ghq root)/$(ghq list | fzf)'
