"for selecting pasted text
"TODO fix the selecting pasted thing
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

"for allowing the path thing
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'


"running code
autocmd FileType python map <buffer> <F9> :exec '!python3' shellescape(@%, 1)<CR>

"for terminal
if has('nvim')
    autocmd TermOpen * setlocal nonumber norelativenumber
endif
