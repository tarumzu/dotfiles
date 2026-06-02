" denite 起動時に使用するキーマップ
" バッファ一覧
noremap <C-P> :Denite buffer<CR>
" ファイル一覧
noremap <C-N> :Denite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Denite file_old<CR>
" カレントディレクトリ
nnoremap <silent> <C-c> :<C-u>Denite file_rec<CR>
"バッファ一覧
nnoremap sB :<C-u>Denite buffer -buffer-name=file<CR>
