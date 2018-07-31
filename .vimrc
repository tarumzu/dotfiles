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

"""""" start dein
" 各プラグインの設定は~/.config/nvim/を参照
if s:vimrc_plugin_on == s:true
  if &compatible
    set nocompatible
  endif

  "# dein.vimインストール時に指定したディレクトリをセット
  let s:dein_dir = expand('~/.cache/dein')

  "# dein.vimの実体があるディレクトリをセット
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

  " dein.vimが存在していない場合はgithubからclone
  if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
  endif

  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    "# dein.toml, dein_layz.tomlファイルのディレクトリをセット
    let s:toml_dir = expand('~/.config/nvim')

    "# 起動時に読み込むプラグイン群
    call dein#load_toml(s:toml_dir . '/dein.toml', {'lazy': 0})

    "# 遅延読み込みしたいプラグイン群
    call dein#load_toml(s:toml_dir . '/dein_lazy.toml', {'lazy': 1})

    call dein#end()
    call dein#save_state()
  endif

  filetype plugin indent on
  syntax enable

  " If you want to install not installed plugins on startup.
  if dein#check_install()
    call dein#install()
  endif
endif
""""""" end dein

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
