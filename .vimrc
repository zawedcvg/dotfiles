"Basic Stuff"
set nocompatible
filetype off
syntax on
set number
set hlsearch
set nrformats=
set relativenumber
set incsearch
"set inccommand=split
set laststatus=2
set clipboard=unnamedplus
set backspace=indent,eol,start
set autoindent
set history=200
set smartindent
set tabstop=4
set expandtab
set pumheight=20
set softtabstop=4
set shiftwidth=4
set ignorecase
set smartcase
nmap Q <Nop>  
nnoremap H gT
nnoremap L gt
set noerrorbells visualbell t_vb=
"colorscheme molokai
set termguicolors
let g:rehash256 = 1
let mapleader=","

filetype plugin indent on
filetype plugin on

"for airline
"let g:airline_theme='onedark'
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#whitespace#enabled = 0
"let g:airline_powerline_fonts = 1

"for NERDtree

"for indentline
"let g:indentLine_color_term = 239
"let g:indentLine_char_list = ['|', '¦', '┆', '┊']

"rainbow brackets
"let g:rainbow#max_level = 16
"let g:rainbow#pairs = [['(', ')'], ['[', ']'], [ '{', '}' ]]

"" List of colors that you do not want. ANSI code or #RRGGBB
"let g:rainbow#blacklist = [233, 234]

""for coc
"" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
"" unicode characters in the file autoload/float.vim
"set encoding=utf-8

"" TextEdit might fail if hidden is not set.
"set hidden

"" Some servers have issues with backup files, see #649.
"set nobackup
"set nowritebackup

"" Give more space for displaying messages.
"set cmdheight=2

"" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
"" delays and poor user experience.
"set updatetime=300

"" Don't pass messages to |ins-completion-menu|.
"set shortmess+=c

"" Always show the signcolumn, otherwise it would shift the text each time
"" diagnostics appear/become resolved.
"if has("patch-8.1.1564")
    "" Recently vim can merge signcolumn and number column into one
    "set signcolumn=number
"else
    "set signcolumn=yes
"endif


""Shorcuts
""mapping to remove highlighting
nnoremap <silent> <cr> :noh<cr><cr>
"shortcutting navigation in split view"
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-l> <c-w>l
map <c-k> <c-w>k
"abbreviations
ab sout system.out.println
ab main_func public static void main(string[] args)

"au VimEnter * RainbowParentheses


"""  set showmatch                  " Briefly jump to a paren once it's balanced
"set matchpairs+=\<:\>
"" With `Cursor guibg=fg guifg=bg` + default MatchParen styling, it makes the
"" cursor seem like it has actually jumped to the patching pair. This instead
"" makes the MatchParen style preserve the background color, so that the
"" Cursor can flip it appropriately.
"hi! MatchParen cterm=NONE,bold gui=NONE,bold guibg=bg guifg=lightblue ctermbg=bg ctermfg=lightblue
