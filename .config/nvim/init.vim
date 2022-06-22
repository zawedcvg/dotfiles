source $HOME/.config/nvim/vim-plug/mapping.vim
source $HOME/.config/nvim/vim-plug/plugins.vim
"source $HOME/.config/nvim/vim-plug/coc.vim
"set rtp+=/home/neeladri/.config/nvim/plugin
lua require("status-line")
lua require("top-bufferline")
lua require("file-icons")
lua require("zawed_telescope")
lua require("zawed_cmp")
lua require("zawed_lsp")
set mouse=a
set signcolumn=number
set splitbelow splitright
"set nocompatible
filetype plugin indent on
filetype plugin on
syntax on
set lazyredraw "for macros
set noshowmode "for preventing the show of modes
set number
set hlsearch
set nrformats=
set relativenumber
set incsearch
set inccommand=split "substitution stuff
set laststatus=2
set clipboard=unnamedplus
set backspace=indent,eol,start
set autoindent
set history=200
set smartindent
set tabstop=4
set expandtab
set pumheight=20 "number of suggestions in coc
set softtabstop=4
set shiftwidth=4
set scrolloff=8
set sidescrolloff=8
set ignorecase
set smartcase
set undofile

" Removes trailing spaces
function TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction

set shortmess+=c
set completeopt=menuone,noinsert,noselect
"autocmd BufWinEnter * call TrimWhiteSpace()
"autocmd BufWinLeave * call TrimWhiteSpace()
"autocmd FilterWritePre * call TrimWhiteSpace()
"autocmd BufWritePre * call TrimWhiteSpace()


map <F2> :call TrimWhiteSpace()<CR>

set list listchars=tab:»·,trail:·

nmap Q <Nop>
nnoremap H gt
nnoremap L gT
set noerrorbells visualbell t_vb=
colorscheme onedark
set termguicolors
"let g:rehash256 = 1

function s:Cursor_Moved()
    let cur_pos = winline()
    if g:last_pos == 0
        set cul
        let g:last_pos = cur_pos
        return
    endif
    let diff = g:last_pos - cur_pos
    if diff > 1 || diff < -1
        set cul
    else
        set nocul
    endif
    let g:last_pos = cur_pos
endfunction
autocmd CursorMoved,CursorMovedI * call s:Cursor_Moved()

let g:last_pos = 0

let g:highlightedyank_highlight_duration = 150

let g:indentLine_fileTypeExclude = ['dashboard', "help"]
nnoremap <silent> <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for > ")})<CR>
nnoremap <silent> <leader>ff :lua require('telescope.builtin').find_files()<cr>
nnoremap <silent> <leader>fb :lua require('telescope.builtin').buffers()<cr>
nnoremap <silent> <leader>fh :lua require('telescope.builtin').help_tags()<cr>
nnoremap <silent> <leader>fc :lua require('zawed_telescope').search_dotfiles()<CR>
nnoremap <silent> <leader>fn :lua require('zawed_telescope').search_nvim()<CR>

"vim latex
let g:Tex_IgnoredWarnings =
    \'Underfull'."\n".
    \'Overfull'."\n".
    \'specifier changed to'."\n".
    \'You have requested'."\n".
    \'Missing number, treated as zero.'."\n".
    \'There were undefined references'."\n".
    \'Citation %.%# undefined'."\n".
    \'Double space found.'."\n"
let g:Tex_IgnoreLevel = 8
let g:netrw_browse_split = 0
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_localrmdir='rm -r'

autocmd FileType python let b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']
"autocmd FileType  txtlet b:coc_root_patterns = ['.git', '.env', 'venv', '.venv', 'setup.cfg', 'setup.py', 'pyproject.toml', 'pyrightconfig.json']
"for vim-rooter
let g:rooter_patterns = ['.git', 'Makefile', '*.sln', 'build/env.sh']
autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()

" in millisecond, used for both CursorHold and CursorHoldI,
" use updatetime instead if not defined
let g:cursorhold_updatetime = 100

lua <<EOF
require'nvim-treesitter.configs'.setup {
    --ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
    enable = true,              -- false will disable the whole extension
    },
}

require 'colorizer'.setup()
--require("nvim-gps").setup({
--icons = {
    --["class-name"] = ' ',      -- Classes and class-like objects
    --["function-name"] = ' ',   -- Functions
    --["method-name"] = ' '      -- Methods (functions inside class-like objects)
    --},
---- Disable any languages individually over here
---- Any language not disabled here is enabled by default
--separator = ' > ',
--})
require('onedark').setup {
    style = 'cool'
}
require("which-key").setup()
require("nvim-ts-autotag").setup()
signature_cfg = {
    hint_enable = false,
}
require "lsp_signature".setup(signature_cfg)
require "fidget".setup()
--require('rust-tools').setup({})
--"require'treesitter-context.config'.setup{
