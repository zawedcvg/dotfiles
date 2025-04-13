vim.g.mapleader = " "

--local telescope = require("telecope.builtin")

-- creating the basic functions to ease
function CreateRemap(type, opts)
    return function(lhs, rhs)
        vim.api.nvim_set_keymap(type, lhs, rhs, opts) end
end

Nnoremap = CreateRemap("n", { noremap = true })
Xnoremap = CreateRemap("x", { noremap = true })
Vmap = CreateRemap("v", {})
Nmap = CreateRemap("n", {})
Cmap = CreateRemap("c", {noremap=true})
Tnoremap = CreateRemap("t", { noremap = true })

--making additional mapping

--for highlighting the current searched word differently
Nnoremap("n", "<Plug>(searchhi-n)zzzv")
Nnoremap("N", "<Plug>(searchhi-N)zzzv")
Nnoremap("*", "<Plug>(searchhi-*)zzzv")
Nnoremap("g*", "<Plug>(searchhi-g*)zzzv")
Nnoremap("#", "<Plug>(searchhi-#)zzzv")
Nnoremap("g#", "<Plug>(searchhi-g#)zzzv")

Vmap("n", "<Plug>(searchhi-v-n)zzzv")
Vmap("N", "<Plug>(searchhi-v-N)zzzv")
Vmap("*", "<Plug>(searchhi-v-*)zzzv")
Vmap("g*", "<Plug>(searchhi-v-g*)zzzv")
Vmap("#", "<Plug>(searchhi-v-#)zzzv")
Vmap("g#", "<Plug>(searchhi-v-g#)zzzv")

vim.api.nvim_set_keymap("n", "<CR>", "<Plug>(searchhi-clear-all)", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<CR>", "<Plug>(searchhi-v-clear-all)", { noremap = true, silent = true })

--changing how go works
Nnoremap("gi", "gi<C-[>zz")

--changing the substition
vim.api.nvim_set_keymap("n", "s", "<plug>(SubversiveSubstitute)", {})
vim.api.nvim_set_keymap("n", "ss", "<plug>(SubversiveSubstituteLine)", {})
vim.api.nvim_set_keymap("n", "S", "s$", {})
--for markdown preview
vim.api.nvim_set_keymap("n", "<C-p>", "<Plug>(MarkdownPreviewToggle)", {})

Xnoremap("<leader>p", "\"_dP")

--Shortcutting navigation in split view"
Nnoremap("<C-h>", "<C-w>h")
Nnoremap("<C-j>", "<C-w>j")
Nnoremap("<C-l>", "<C-w>l")
Nnoremap("<C-k>", "<C-w>k")
Nnoremap("<C-p>", "<C-w>p")

--set the scrolling to be centered
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

--for setting m as a cut key
Nnoremap("gm", "m")
Nnoremap("m", "d")
Xnoremap("m", "d")
Nnoremap("mm", "dd")
Nnoremap("M", "D")


--unimpaired stuff
Nnoremap("]q", "<cmd>cnext<CR>")
Nnoremap("[q", "<cmd>cprev<CR>")
Nnoremap("]b", "<cmd>bnext<CR>")
Nnoremap("[b", "<cmd>bprev<CR>")

--Bubble single lines
Nmap("<C-Up>", "[e")
Nmap("<C-Down>", "]e")

--Bubble multiple lines
Vmap("<C-Up>", "[egv")
Vmap("<C-Down>", "]egv")

--git setup
vim.api.nvim_set_keymap("n", "<leader>gs", ":Git<CR><C-w>x", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gc", ":Git commit<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<leader>gk", ":diffget //2", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "<leader>gd", ":diffget //3", { noremap = true, silent = true })
Nnoremap("]c", "]czz")
Nnoremap("[c", "[czz")

vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>Trouble diagnostics toggle<CR>",
    { noremap = true, silent = true, nowait = true })


--handling mistypes
Cmap("WQ", "wq")
Cmap("Wq", "wq")
Cmap("W", "w")
Cmap("Q", "q")
Cmap("Qa", "qa")

--Nnoremap(":W<CR>", ":w<CR>")

vim.api.nvim_set_keymap("n", "<leader>fj", "<cmd>Telescope jumplist<CR>",
    { noremap = true, silent = true, nowait = true })
vim.api.nvim_set_keymap("n", "gr", "<cmd>Telescope lsp_references<CR>",
    { noremap = true, silent = true, nowait = true })

--terminal things
Tnoremap("<Esc>", "<C-\\><C-n>")
Tnoremap("<leader>[", "<Esc>")
Tnoremap("<C-h>", "<C-\\><C-n><C-w>h")
Tnoremap("<C-j>", "<C-\\><C-n><C-w>j")
Tnoremap("<C-k>", "<C-\\><C-n><C-w>k")
Tnoremap("<C-l>", "<C-\\><C-n><C-w>l")
--Tnoremap("<C-w>", "<C-\\><C-n><C-w>w")
vim.api.nvim_set_keymap("n", "<leader>t", "<cmd>sp<CR>:terminal<CR>:resize -10<CR>a", {noremap = true, silent = true})
--vim.keymap.set(
  --"",
  --"<Leader>l",
  --require("lsp_lines").toggle,
  --{ desc = "Toggle lsp_lines" }
--)


-- Obsidian Mappings
Nnoremap("<leader>os", "<cmd>ObsidianSearch<CR>")
Nnoremap("<leader>od", "<cmd>ObsidianToday<CR>")
Nnoremap("<leader>ot", "<cmd>ObsidianTags<CR>")
Nnoremap("<leader>oc", "<cmd>ObsidianTOC<CR>")


-- Oil key bindings
Nnoremap("-", "<cmd>Oil --float .<CR>")
Nnoremap("_", "<cmd>Oil --float ..<CR>")

-- Neogen keybinds
Nnoremap("<Leader>nf", ":lua require('neogen').generate({ type = 'func' })<CR>")
Nnoremap("<Leader>nc", ":lua require('neogen').generate({ type = 'class' })<CR>")

--Glance keybinds
Nnoremap("gD", "<cmd>Glance definitions<CR>")
Nnoremap("gR", "<cmd>Glance references<CR>")

--symbols outline
Nnoremap("<Leader>s", "<cmd>Outline!<CR>")


Nnoremap("<leader><leader>f", "<cmd>lua require('conform').format()<CR>")


local api = require('Comment.api')
local config = require('Comment.config'):get()

Nnoremap("<leader>cu", "<cmd>lua require('Comment.api').uncomment.linewise.current()<CR>")
Vmap("<leader>cu", "<cmd>lua require('Comment.api').uncomment.linewise.current()<CR>")


Nnoremap("<leader>p", "<cmd>lua require('nabla').toggle_virt()<CR>") -- Customize with popup({border = ...})  : `single` (default), `double`, `rounded`)

-- api.uncomment.linewise(motion, config?)
-- api.uncomment.linewise.current(motion?, config?)
-- api.uncomment.linewise.count(count, config?)
--
-- api.uncomment.blockwise(motion, config?)
-- api.uncomment.blockwise.current(motion?, config?)
-- api.uncomment.blockwise.count(count, config?)
