nnoremap <SPACE> <Nop>
let mapleader=" "
let g:coc_snippet_next = '<tab>'

nmap n <Plug>(searchhi-n)zzzv
nmap N <Plug>(searchhi-N)zzzv
nmap * <Plug>(searchhi-*)zzzv
nmap g* <Plug>(searchhi-g*)zzzv
nmap # <Plug>(searchhi-#)zzzv
nmap g# <Plug>(searchhi-g#)zzzv
nmap gi gi<C-[>zz

vmap n <Plug>(searchhi-v-n)zzzv
vmap N <Plug>(searchhi-v-N)zzzv
vmap * <Plug>(searchhi-v-*)zzzv
vmap g* <Plug>(searchhi-v-g*)zzzv
vmap # <Plug>(searchhi-v-#)zzzv
vmap g# <Plug>(searchhi-v-g#)zzzv
"nnoremap <silent> <CR> :noh<CR>
nmap <silent> <CR> <Plug>(searchhi-clear-all)
vmap <silent> <CR> <Plug>(searchhi-v-clear-all)
"nnoremap <CR> <Plug>(searchhi-clear-all)
"for subversive
" s for substitute
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S s$

nnoremap <silent> <C-d> <C-d>zz
nnoremap <silent> <C-u> <C-u>zz
nnoremap Y y$

"for markdown preview
nmap <C-p> <Plug>MarkdownPreviewToggle



"imap <C-BS> <C-W>
"for emmet
let g:user_emmet_leader_key='<C-e>'

"for indent
let g:indent_blankline_char = '▏'

"prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile
"map <silent> <leader>p :Prettier<CR>
let g:prettier#autoformat_config_present = 1
let g:prettier#autoformat_require_pragma = 0


let g:EasyClipUseSubstituteDefaults=1
"Shorcuts
""mapping to remove highlighting
"Shortcutting navigation in split view"
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
"for setting m as a cut key
nnoremap gm m
nnoremap m d
xnoremap m d
nnoremap mm dd
nnoremap M D
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv
"nnoremap <silent> <leader>b :ToggleBlameLine<CR>
"transparent
nnoremap <silent> <C-f> :hi Normal guibg=NONE ctermbg=NONE<CR>
"Abbreviations
ab sout System.out.println
ab main_func public static void main(String[] args)

"Telescope

nnoremap <leader>fj :Telescope jumplist<CR>


"git setup
nnoremap <silent> <leader>gs :Git<CR><C-w>x
nnoremap <silent> <leader>gc :Git commit<CR>
nnoremap <silent> <leader>gd :diffget //2
nnoremap <silent> <leader>gl :diffget //3
nnoremap ]c ]czz
nnoremap [c [czz

"for selecting pasted text
nnoremap gp `[v`]

"for jumplist modification
"nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
"nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

nnoremap <F5> :UndotreeToggle<CR>
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>rc <Plug>(coc-refactor)


"opening netwr
nnoremap <silent> <leader>o :Vex<CR>

"for buffer
nnoremap <silent> <leader>bd :BufferLineCloseLeft<CR>
nnoremap <silent> <leader>bl :BufferLineCloseRight<CR>


"set matchpairs+=\<:\>
" With `Cursor guibg=fg guifg=bg` + default MatchParen styling, it makes the
" cursor seem like it has actually jumped to the patching pair. This instead
" makes the MatchParen style preserve the background color, so that the
" Cursor can flip it appropriately.
"hi! MatchParen cterm=NONE,bold gui=NONE,bold guibg=bg guifg=lightblue ctermbg=bg ctermfg=lightblue

"for allowing the path thing
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
command WQ wq
command Wq wq
command W w
command Q q
command Qa qa


"running code
autocmd FileType python map <buffer> <F9> :exec '!python3' shellescape(@%, 1)<CR>
"autocmd Filetype python nnoremap <buffer> <leader>rp :!python3 %<CR>

"to enable highlighting while jumping
" blink_search.vim - Blink search pattern after n and N
"function! s:BlinkCurrentMatch()
    "let target = '\c\%#'.@/
    "let match = matchadd('IncSearch', target)
    "redraw
    "sleep 90m
    "call matchdelete(match)
    "redraw
"endfunction

"stuff for search

"for terminal
if has('nvim')
    tnoremap <Esc> <C-\><C-n>
    tnoremap <leader>[ <Esc>
    tnoremap <C-h> <C-\><C-n><C-w>h
    tnoremap <C-j> <C-\><C-n><C-w>j
    tnoremap <C-k> <C-\><C-n><C-w>k
    tnoremap <C-l> <C-\><C-n><C-w>l
    nnoremap <leader>t :sp<CR>:terminal<CR>:resize -10<CR>a
    autocmd TermOpen * setlocal nonumber norelativenumber
endif

"autocmd TermOpen * :
