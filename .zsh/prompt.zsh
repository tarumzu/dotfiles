# starship プロンプト (設定は ~/.config/starship.toml)
if command -v starship > /dev/null; then
  eval "$(starship init zsh)"
fi

autoload -Uz add-zsh-hook

# ターミナルタイトルにカレントディレクトリ名を表示
_set_term_title() { print -Pn "\e]0;%1~\a" }
add-zsh-hook precmd _set_term_title

# cd したあとで自動的にリスト表示 (eza 優先)
if command -v eza > /dev/null; then
  _auto_ls() { eza --git }
else
  _auto_ls() { ls }
fi
add-zsh-hook chpwd _auto_ls
