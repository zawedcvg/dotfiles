return {
	-- Core setup
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-lua/popup.nvim" },
	{ "nvim-tree/nvim-web-devicons", opts = {} },

	-- UI Enhancements
	{ "MunifTanjim/nui.nvim" },
	{ "rcarriga/nvim-notify" },
	{ "folke/noice.nvim", dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" } },
	{ "folke/which-key.nvim" },
	{ "b0o/incline.nvim" },
	{ "stevearc/dressing.nvim" },

	-- Statusline and Tabs
	{ "glepnir/galaxyline.nvim", branch = "main" },
	{ "alvarosevilla95/luatab.nvim" },

	-- Colorschemes
	{ "navarasu/onedark.nvim" },
	{ "sainnhe/everforest" },
	{ "catppuccin/nvim", name = "catppuccin", lazy = false },
	{ "rebelot/kanagawa.nvim" },
	{ "sho-87/kanagawa-paper.nvim" },
	{ "AlexvZyl/nordic.nvim", branch = "main" },

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{ "nvim-treesitter/nvim-treesitter-textobjects" },
	{ "windwp/nvim-ts-autotag" },

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
	},

	-- Git
	{ "tpope/vim-fugitive" },
	{
		"lewis6991/gitsigns.nvim",
		cmd = { "Gitsigns" },
	},
	{ "sindrets/diffview.nvim" },

	-- Editing
	{ "tpope/vim-surround" },
	{ "tpope/vim-repeat" },
	{ "svermeulen/vim-subversive" },
	{ "svermeulen/vim-cutlass" },
	{ "nelstrom/vim-visual-star-search" },
	{ "lukas-reineke/indent-blankline.nvim" },
	{ "raimondi/delimitmate" },
	{ "numToStr/Comment.nvim" },

	-- Markdown and LaTeX
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown", "vim-plug" },
		build = "cd app && yarn install",
	},
	{ "lervag/vimtex", ft = { "markdown" } },

	-- Startup Time
	{ "dstein64/vim-startuptime" },

	-- Completion
	-- Uncomment if needed:
	-- { "hrsh7th/nvim-cmp" },
	-- { "hrsh7th/cmp-nvim-lsp" },
	-- { "hrsh7th/cmp-buffer" },
	-- { "hrsh7th/cmp-path" },
	-- { "hrsh7th/cmp-cmdline" },
	--
	--
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		-- dependencies = { 'rafamadriz/friendly-snippets' },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "default",
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				-- ["<Esc>"] = { "hide", "fallback" },
				["<PageUp>"] = { "scroll_documentation_up", "fallback" },
				["<PageDown>"] = { "scroll_documentation_down", "fallback" },
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				documentation = { auto_show = true },
				list = { selection = { preselect = false, auto_insert = true } },
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			--
			signature = { enabled = true },

			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "rust" },
		},
		opts_extend = { "sources.default" },
	},
	{ "L3MON4D3/LuaSnip", opts = {} },

	-- LSP
	{ "neovim/nvim-lspconfig" },
	-- { "microsoft/python-type-stubs" },
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "j-hui/fidget.nvim" },
	{ "folke/trouble.nvim" },
	{ "stevearc/conform.nvim" },
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				python = { "ruff" },
			}
		end,
	},
	-- { "zapling/mason-conform.nvim" },
	{ "simrat39/rust-tools.nvim" },
	{ "p00f/clangd_extensions.nvim" },
	{ "SmiteshP/nvim-navic" },
	{ "RRethy/vim-illuminate" },
	{ "dnlhc/glance.nvim" },

	-- Writing Tools
	{ "junegunn/goyo.vim", cmd = "Goyo" },
	{ "OXY2DEV/markview.nvim" },
	{ "epwalsh/obsidian.nvim" },
	-- { "3rd/image.nvim" },
	--
	--
	{
		"folke/snacks.nvim",
		---@type snacks.Config
		opts = {
			image = {
				-- your image configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
		},
	},
	{ "jbyuki/nabla.nvim" },

	-- Notes and Structure
	{ "nvim-neorg/neorg", tag = "v7.0.0" },

	-- Utilities
	{ "hedyhli/outline.nvim" },
	{ "tyru/open-browser.vim" },
	{ "zawedcvg/distant.nvim" },
	{ "stevearc/oil.nvim" },
	{ "danymat/neogen" },
	{ "qxxxb/vim-searchhi" },
	{ "folke/todo-comments.nvim" },

	--- Debugger
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		-- Copied from LazyVim/lua/lazyvim/plugins/extras/dap/core.lua and
		-- modified.
		keys = {
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},

			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},

			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},

			{
				"<leader>dT",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
		},
	},
}
