vim.cmd [[
ab sout System.out.println
ab main_func public static void main(String[] args)
]]

local set = vim.o


vim.opt.listchars = { tab = '▸ ', trail = '·' }
vim.opt.fillchars = {
  diff = "╱", -- alternatives = ⣿ ░ ─ ╱
}
vim.opt.conceallevel = 2
set.list = true

--set.lazyredraw = true --for macros
--set.noshowmode = true --for preventing the show of modes
set.number = true
set.hlsearch = true
set.nrformats = 'unsigned'
set.relativenumber = true
set.incsearch = true
set.inccommand = 'split' --substitution stuff
set.laststatus = 3
set.clipboard = 'unnamedplus'
set.backspace = 'indent,eol,start'
set.autoindent = true
set.history = 200
set.smartindent = true
set.tabstop = 4
set.expandtab = true
set.pumheight = 20 --number of suggestions in coc
set.softtabstop = 4
set.shiftwidth = 4
--scrolling doesnt require to go to end of the file
set.scrolloff = 8
set.sidescrolloff = 8
set.ignorecase = true
set.smartcase = true
set.undofile = true

--for emmet
vim.g['user_emmet_leader_key'] = '<C-e>'

--for indentblankline
vim.g['indent_blankline_char'] = '▏'

--for prettier
vim.g['prettier#autoformat_config_present'] = 1
vim.g['prettier#autoformat_require_pragma'] = 0
vim.g['EasyClipUseSubstituteDefaults'] = 1

--filetype.nvim 
vim.g['did_load_filetypes'] = 1
vim.g['do_filetype_lua'] = 1

--for colorscheme
vim.g['everforest_background'] = 'medium'
vim.g['everforest_enable_italic'] = 1
vim.cmd("colorscheme everforest")
--vim.g['everforest_background'] = 'medium'
--vim.g['everforest_enable_italic'] = 1
--vim.cmd("colorscheme everforest")
--vim.cmd[[colorscheme everforest]]
--let g:everforest_background = 'medium'
--let g:everforest_enable_italic = 1
set.mouse = 'a'
set.signcolumn = "number"
vim.cmd [[set splitbelow splitright
]]
