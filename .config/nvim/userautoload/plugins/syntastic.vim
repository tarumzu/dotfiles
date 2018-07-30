" syntastic
" let g:syntastic_debug = 1 " デバッグ用
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_mode_map = { 'mode': 'passive',
                            \ 'active_filetypes': ['ruby', 'javascript', 'coffee', 'css', 'scss', 'sass', 'xml', 'yaml', 'json'] }
let g:syntastic_ruby_exec = '~/.rbenv/shims/ruby'
let g:syntastic_ruby_rubocop_exec = '~/.rbenv/shims/rubocop'
let g:syntastic_ruby_checkers = ['mri', 'rubocop']

nnoremap <silent> <Leader>sm :<C-u>SyntasticCheck mri <CR>
nnoremap <silent> <Leader>sr :<C-u>SyntasticCheck rubocop <CR>
