local actions = require("telescope.actions")
require('telescope').setup({
    defaults = {
        file_ignore_patterns = { 'autoload', '.git', 'node_modules', 'target', 'build'},
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            prompt_position = "top",
            horizontal = {
                mirror = false,
            },
            vertical = {
                mirror = true,
            },
        },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            }
        }
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        }
    }

})
local M = {}
M.search_dotfiles = function()
    require("telescope.builtin").find_files({
        prompt_title = "< Config >",
        cwd = "~/.config/nvim",
        hidden = true,
    })
end
M.search_nvim = function()
    require("telescope.builtin").live_grep({
        file_ignore_patterns = { "autoload/.*" },
        prompt_title = "< Nvim >",
        cwd = "~/.config/nvim",
        search_dirs = { "lua", "vim-plug" },
        hidden = true,
    })
end


M.search_obsidian = function()
    require("telescope.builtin").find_files({
        prompt_title = "< Obsidian >",
        cwd = "~/Final Vault",
        hidden = false,
    })
end


require('telescope').load_extension('fzf')
return M
