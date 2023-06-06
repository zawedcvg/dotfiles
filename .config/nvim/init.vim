"lua require('impatient')
runtime! plugin/rplugin.vim
source $HOME/.config/nvim/vim-plug/plugins.vim
lua require('impatient')
lua require("user")
lua require("zawed_lsp")
lua require("zawed_plugin")
autocmd BufNewFile,BufRead *.h set ft=cpp
syntax on
set noshowmode "for preventing the show of modes

nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <Tab> gt
nnoremap <S-Tab> gT

set foldlevelstart=99

nnoremap <silent> <C-Down> :m .+1<CR>==
nnoremap <silent> <C-Up> :m .-2<CR>==
inoremap <silent> <C-Down> <Esc>:m .+1<CR>==gi
inoremap <silent> <C-Up> <Esc>:m .-2<CR>==gi
vnoremap <silent> <C-Up> :m '<-2<CR>gv=gv
vnoremap <silent> <C-Down> :m '>+1<CR>gv=gv
command W w
command Wq wq
command Qa qa
command Q q
"command Q! q!

set splitkeep=screen

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

autocmd FileType txt map <buffer> j gj
autocmd FileType txt map <buffer> k gk

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

"" in millisecond, used for both CursorHold and CursorHoldI,
"" use updatetime instead if not defined
"let g:cursorhold_updatetime = 100

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
"let g:loaded_netrw             = 1
"let g:loaded_netrwPlugin       = 1
let g:loaded_tutor_mode_plugin = 1
let g:loaded_remote_plugins    = 1

function! s:goyo_enter()
  set noshowmode
  set noshowcmd
  Limelight
  set laststatus=3
  IlluminateToggleBuf
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()

lua << EOF
--require('colorful-winsep').setup({})
require'nvim-treesitter.configs'.setup {
    --ensure_installed = {"norg"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
    enable = true,              -- false will disable the whole extension
    },
}

require('distant').setup {
    --['*'] = require('distant.settings').chip_default()
    ['idsd-0.d2.comp.nus.edu.sg'] = {
        distant = {
            bin = '/home/neeladri/distant-linux64-gnu'
        }
    }
}
require("which-key").setup()
require("nvim-ts-autotag").setup()
signature_cfg = {
    hint_enable = false,
}
require("lsp_signature").setup(signature_cfg)
require("fidget").setup()
require("trouble").setup {
}
require('luatab').setup{
    windowCount = function() return '' end,
}

local function get_diagnostic_label(props)
  local icons = {
    Error = '',
    Warn = '',
    Info = '',
    Hint = '',
  }

  local label = {}
  for severity, icon in pairs(icons) do
    local n = #vim.diagnostic.get(props.buf, { severity = vim.diagnostic.severity[string.upper(severity)] })
    if n > 0 then
      table.insert(label, { icon .. ' ' .. n .. ' ', group = 'DiagnosticSign' .. severity })
    end
  end
  return label
end

require("incline").setup({
  debounce_threshold = { falling = 500, rising = 250 },
  render = function(props)
    local bufname = vim.api.nvim_buf_get_name(props.buf)
    local filename = vim.fn.fnamemodify(bufname, ":t")
    local diagnostics = get_diagnostic_label(props)
    local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold,italic" or "None"
    local filetype_icon, color = require("nvim-web-devicons").get_icon_color(filename)

    local buffer = {
        { filetype_icon, guifg = color },
        { " " },
        { filename, gui = modified },
    }

    if #diagnostics > 0 then
        table.insert(diagnostics, { "| ", guifg = "grey" })
    end
    for _, buffer_ in ipairs(buffer) do
        table.insert(diagnostics, buffer_)
    end
    return diagnostics
  end,
})
local function get_git_diff()
  local icons = { removed = "", changed = "",added = "" }
  local labels = {}
  local signs = vim.b.gitsigns_status_dict
  for name, icon in pairs(icons) do
    if tonumber(signs[name]) and signs[name] > 0 then
      table.insert(labels, { icon .. " ".. signs[name] .. " ",
        group = "Diff" .. name
      })
    end
  end
  if #labels > 0 then
    table.insert(labels, {'| '})
  end
  return labels
end
require('neorg').setup {
    load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.export"] = {}, -- exporting?
        ["core.export.markdown"] = {
            config = {
                extensions = "all",
                },
        },
        ["core.norg.dirman"] = { -- Manages Neorg workspaces
            config = {
                workspaces = {
                    notes = "~/notes",
                    todo = "~/todo",
                    finals = "~/finals_prep",
                    projects = "~/projects",
                },
            },
        },
        ["core.keybinds"] = {
            config = {
                neorg_leader = "<Leader>",
            }
        }
    },
}

local glance = require('glance')
local actions = glance.actions

glance.setup({
  height = 18, -- Height of the window
  zindex = 45,
  preview_win_opts = { -- Configure preview window options
    cursorline = true,
    number = true,
    wrap = true,
  },
  border = {
    enable = false, -- Show window borders. Only horizontal borders allowed
    top_char = '―',
    bottom_char = '―',
  },
  list = {
    position = 'right', -- Position of the list window 'left'|'right'
    width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
  },
  theme = { -- This feature might not work properly in nvim-0.7.2
    enable = true, -- Will generate colors for the plugin based on your current colorscheme
    mode = 'auto', -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
  },
  mappings = {
    list = {
      ['j'] = actions.next, -- Bring the cursor to the next item in the list
      ['k'] = actions.previous, -- Bring the cursor to the previous item in the list
      ['<Down>'] = actions.next,
      ['<Up>'] = actions.previous,
      ['<Tab>'] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
      ['<S-Tab>'] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
      ['<C-u>'] = actions.preview_scroll_win(5),
      ['<C-d>'] = actions.preview_scroll_win(-5),
      ['v'] = actions.jump_vsplit,
      ['s'] = actions.jump_split,
      ['t'] = actions.jump_tab,
      ['<CR>'] = actions.jump,
      ['o'] = actions.jump,
      ['<leader>l'] = actions.enter_win('preview'), -- Focus preview window
      ['q'] = actions.close,
      ['Q'] = actions.close,
      ['<Esc>'] = actions.close,
      -- ['<Esc>'] = false -- disable a mapping
    },
    preview = {
      ['Q'] = actions.close,
      ['<Tab>'] = actions.next_location,
      ['<S-Tab>'] = actions.previous_location,
      ['<leader>l'] = actions.enter_win('list'), -- Focus list window
    },
  },
  hooks = {},
  folds = {
    fold_closed = '',
    fold_open = '',
    folded = true, -- Automatically fold list on startup
  },
  indent_lines = {
    enable = true,
    icon = '│',
  },
  winbar = {
    enable = true, -- Available strating from nvim-0.8+
  },
})
