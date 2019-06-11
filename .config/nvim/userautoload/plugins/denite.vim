""denite時に使用するキーマップ
""ESCキーでdeniteを終了
"call denite#custom#map('insert', '<esc>', '<denite:enter_mode:normal>', 'noremap')
"call denite#custom#map('normal', '<esc>', '<denite:quit>', 'noremap')
""C-J,C-Kで上下移動
"call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
"call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')
""C-N,C-Pでsplitで開く
"call denite#custom#map('insert', '<C-s>', '<denite:do_action:split>', 'noremap')
"call denite#custom#map('insert', '<C-v>', '<denite:do_action:vsplit>', 'noremap')

" 以下はdenite起動時に使用するキーマップ
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
