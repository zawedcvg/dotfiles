runtime! plugin/rplugin.vim
source $HOME/.config/nvim/vim-plug/plugins.vim
"source $HOME/.config/nvim/vim-plug/mapping.vim
lua require("user")
lua require("zawed_lsp")
lua require("zawed_plugin")
syntax on
set noshowmode "for preventing the show of modes

nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

"for allowing the path thing
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
let g:jupytext_fmt = 'py'
"for virtual text
hi DiagnosticVirtualTextError guifg=#e67e80
hi DiagnosticVirtualTextWarn  guifg=#dbbc7f
hi DiagnosticVirtualTextInfo  guifg=#7fbbb3
hi DiagnosticVirtualTextHint  guifg=#83c092

"running code
autocmd FileType python map <buffer> <F9> :exec '!python3' shellescape(@%, 1)<CR>

autocmd FileType txt map j gj
autocmd FileType txt map k gk

"for terminal
autocmd TermOpen * setlocal nonumber norelativenumber

" Removes trailing spaces
function TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction

set shortmess+=c
set completeopt=menuone,noinsert,noselect

nnoremap <F2> :call TrimWhiteSpace()<CR>

set termguicolors

"highlight on cursor hold setting
let g:Illuminate_delay = 200
let g:openbrowser_search_engines = extend(
\ get(g:, 'openbrowser_search_engines', {}),
\ {
\ 'opengl': 'https://registry.khronos.org/OpenGL-Refpages/gl2.1/xhtml/{query}.xml'
\ },
\ 'keep'
\)
nnoremap <silent> <leader>osg :call openbrowser#smart_search(expand('<cword>'), "opengl")<CR>

let g:last_pos = 0

"hi IncSearch cterm=NONE ctermfg=yellow ctermbg=green
au TextYankPost * silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}

let g:indentLine_fileTypeExclude = ['dashboard', "help"]
nnoremap <silent> <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for > ")})<CR>
nnoremap <silent> <leader>ff :lua require('telescope.builtin').find_files()<cr>
nnoremap <silent> <leader>fb :lua require('telescope.builtin').buffers()<cr>
nnoremap <silent> <leader>fh :lua require('telescope.builtin').help_tags()<cr>
nnoremap <silent> <leader>fc :lua require('zawed_plugin.telescope').search_dotfiles()<CR>
nnoremap <silent> <leader>fn :lua require('zawed_plugin.telescope').search_nvim()<CR>
nnoremap <silent> <leader>rn :lua require('zawed_lsp.handlers').renameqf()<CR>


"vim latex
"let g:Tex_IgnoredWarnings =
    "\'Underfull'."\n".
    "\'Overfull'."\n".
    "\'specifier changed to'."\n".
    "\'You have requested'."\n".
    "\'Missing number, treated as zero.'."\n".
    "\'There were undefined references'."\n".
    "\'Citation %.%# undefined'."\n".
    "\'Double space found.'."\n"
"let g:Tex_IgnoreLevel = 8

" in millisecond, used for both CursorHold and CursorHoldI,
" use updatetime instead if not defined
let g:cursorhold_updatetime = 100

"disable inbuilt stuff
let g:loaded_matchparen        = 1
let g:loaded_matchit           = 1
let g:loaded_logiPat           = 1
let g:loaded_rrhelper          = 1
let g:loaded_tarPlugin         = 1
let g:loaded_gzip              = 1
let g:loaded_zipPlugin         = 1
let g:loaded_2html_plugin      = 1
let g:loaded_shada_plugin      = 1
let g:loaded_spellfile_plugin  = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_remote_plugins    = 1

function! s:goyo_enter()
  set noshowmode
  set noshowcmd
  "set scrolloff=999
  Limelight
  set laststatus=3
  IlluminationDisable
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()

lua <<EOF
require'nvim-treesitter.configs'.setup {
    --ensure_installed = {"norg"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
    enable = true,              -- false will disable the whole extension
    },
}
require 'colorizer'.setup()
require("which-key").setup()
require("nvim-ts-autotag").setup()
signature_cfg = {
    hint_enable = false,
}
require("lsp_signature").setup(signature_cfg)
require("fidget").setup()
require("trouble").setup {
}
require('luatab').setup{}
--require('neorg').setup {
    ---- Tell Neorg what modules to load
    --load = {
        --["core.defaults"] = {}, -- Load all the default modules
        --["core.norg.concealer"] = {}, -- Allows for use of icons
        ----["core.norg.dirman"] = { -- Manage your directories with Neorg
            ----config = {
                ----workspaces = {
                ----},
                ----autodetect = true,
                ----autochdir = true,
            ----}
        ----},
        --["core.norg.completion"] = {
            --config = {
                --engine = "nvim-cmp"
            --}
        --}
    --},
--}
require'mind'.setup()
--require 'treesitter-context'.setup{
    --max_lines = 1,
--}
