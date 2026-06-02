" プラグイン管理は Neovim (~/.config/nvim, lazy.nvim) に集約。
" この .vimrc は素の Vim 用の最小設定のみを持つ。
if &compatible
  set nocompatible
endif
filetype plugin indent on

" 色々設定
syntax enable      " シンタックスハイライト
set history=1000   " コマンドの履歴
set clipboard+=unnamedplus " クリップボード共有
set autoindent    " インデント
set hlsearch      " 検索結果文字列のハイライト
set shiftwidth=2  " autoindentなどの時のタブ幅
set tabstop=2     " タブキーで入力したときのタブ幅
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
