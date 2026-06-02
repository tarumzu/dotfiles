# 補完機能の強化
autoload -U promptinit; promptinit
autoload -Uz colors; colors
autoload -Uz vcs_info
autoload -Uz is-at-least

# 直前コマンドの成否で顔文字が変わるプロンプト (liquidprompt の prompt_tag)
ok="* '-'）"
ng="*｀д´）"
p_prompt="
%(?.%{$fg[green]%}.%{$fg[red]%})%(?!$ok!$ng)%{${reset_color}%} "
prompt_tag "$p_prompt"

RPROMPT="[%*]"

# ターミナルタイトルにカレントディレクトリ名を表示
precmd() {
   local pwd=$(pwd)
   local cwd=${pwd##*/}
   print -Pn "\e]0;$cwd\a"
}

# cd したあとで自動的に ls する
function chpwd() { ls }
