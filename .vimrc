" dein設定
if !&compatible
  set nocompatible
endif
" reset augroup
augroup MyAutoCmd
  autocmd!
augroup END

"""""" start vim開発用のテストモード(プラグイン無効)
let s:true  = 1
let s:false = 0
let s:vimrc_plugin_on = get(g:, 'vimrc_plugin_on', s:true)
if len(findfile(".development.vim", ".;")) > 0
  let s:vimrc_plugin_on = s:false
  set runtimepath&
  execute 'set runtimepath+=' . getcwd()
  for plug in split(glob(getcwd() . "/*"), '\n')
    execute 'set runtimepath+=' . plug
  endfor
endif
""""""" end

if s:vimrc_plugin_on == s:true
  let s:cache_home = empty($XDG_CACHE_HOME) ? expand('~/.cache') : $XDG_CACHE_HOME
  let s:dein_dir = s:cache_home . '/dein'
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
  endif
  let &runtimepath = s:dein_repo_dir .",". &runtimepath
  " プラグイン読み込み＆キャッシュ作成
  let s:toml = fnamemodify(expand('<sfile>'), ':h').'/dein.toml'
  let s:lazy_toml = fnamemodify(expand('<sfile>'), ':h').'/dein_lazy.toml'
  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)
    call dein#load_toml(s:toml)
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    call dein#end()
    call dein#save_state()
  endif
  " 未インストールプラグインの自動インストール
  if has('vim_starting') && dein#check_install()
    call dein#install()
  endif
endif

" 色々設定
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4
" 奇数インデントのカラー
hi IndentGuidesOdd  guibg=red   ctermbg=3
" 偶数インデントのカラー
hi IndentGuidesEven guibg=green ctermbg=4
set history=1000   " コマンドの履歴
set clipboard+=unnamedplus " クリップボード共有
set autoindent    " インデント
set hlsearch      " 検索結果文字列のハイライト
set shiftwidth=2  " autoindentなどの時のタブ幅
set tabstop=2     " タブキーで入力したときのタブ幅
set hlsearch      " 検索結果文字列のハイライト
set showmatch     " 閉じ括弧が入力されたとき、対応する括弧を表示
set smartcase     " 検索時に大文字を含んでいたら大/小を区別
set expandtab     " タブを半角スペースに
set laststatus=2  " ステータス常に表示
set visualbell    " エラー時、ビープ音ではなく画面フラッシュ
set list          " リストモード 詳細は下記
set listchars=tab:>-,trail:~,nbsp:-,extends:>,precedes:< " 末尾文字の可視化
set number        " 行番号
set backspace=start,eol,indent " インサートモード時の文字削除
set ruler         " カーソル位置表示
let mapleader = "," " leaderを,に設定
syntax on

" Escの3回押しでハイライト消去
nmap <ESC><ESC><ESC> :nohlsearch<CR><ESC>

let g:neomru#time_format = "(%Y/%m/%d %H:%M:%S) "

" statusline
set statusline=%{expand('%:p:t')}\ %<\(%{SnipMid(expand('%:p:h'),80-len(expand('%:p:t')),'...')}\)%=\ %m%r%y%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}[%3l,%3c]

function! SnipMid(str, len, mask)
  if a:len >= len(a:str)
    return a:str
  elseif a:len <= len(a:mask)
    return a:mask
  endif

  let len_head = (a:len - len(a:mask)) / 2
  let len_tail = a:len - len(a:mask) - len_head

  return (len_head > 0 ? a:str[: len_head - 1] : '') . a:mask . (len_tail > 0 ? a:str[-len_tail :] : '')
endfunction

let g:neosnippet#snippets_directory = '~/.vim/snippets/'
" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
" SuperTab like snippets behavior.
" imap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
"imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
"smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
