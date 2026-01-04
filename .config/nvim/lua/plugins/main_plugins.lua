return {
	-- Core setup
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-lua/popup.nvim" },
	{ "nvim-tree/nvim-web-devicons", opts = {} },

	-- UI Enhancements
	{ "MunifTanjim/nui.nvim" },
	{ "rcarriga/nvim-notify" },
	{
		"folke/noice.nvim",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					--     ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
				signature = {
					enabled = true,
					auto_open = {
						enabled = false,
					},
				},
			},
			cmdline = {
				enabled = true,
				--view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = false, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
			routes = {
				{
					view = "notify",
					filter = { event = "msg_showmode" },
				},
			},
		},
	},
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
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy",
		priority = 1000,
		config = function()
			require("tiny-inline-diagnostic").setup()

			vim.diagnostic.config({
				virtual_text = false, -- Often set to false to avoid clutter, but can be true
				float = false,
				signs = {
					enable = true, -- Ensure signs are enabled
					text = {
						-- Define icons for each severity level
						[vim.diagnostic.severity.ERROR] = " ", -- Example: Error (Unicode)
						[vim.diagnostic.severity.WARN] = " ", -- Example: Warning
						[vim.diagnostic.severity.HINT] = " ", -- Example: Hint
						[vim.diagnostic.severity.INFO] = " ", -- Example: Information
					},
				},
			})
		end,
	},
	{ "neovim/nvim-lspconfig" },
	-- { "microsoft/python-type-stubs" },
	{ "mason-org/mason.nvim" },
	{
		"mason-org/mason-lspconfig.nvim",
	},
	{ "j-hui/fidget.nvim" },
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
	},
	-- dap setup
	{ "rcarriga/nvim-dap-ui", enabled = false },
	{
		"miroshQa/debugmaster.nvim",
		-- osv is needed if you want to debug neovim lua code. Also can be used
		-- as a way to quickly test-drive the plugin without configuring debug adapters
		dependencies = { "mfussenegger/nvim-dap", "jbyuki/one-small-step-for-vimkind" },
		config = function()
			local dm = require("debugmaster")
			-- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
			-- Alternative keybindings to "<leader>d" could be: "<leader>m", "<leader>;"
			vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { nowait = true })
			-- If you want to disable debug mode in addition to leader+d using the Escape key:
			-- vim.keymap.set("n", "<Esc>", dm.mode.disable)
			-- This might be unwanted if you already use Esc for ":noh"
			vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

			dm.plugins.osv_integration.enabled = true -- needed if you want to debug neovim lua code
			local dap = require("dap")
			-- Configure your debug adapters here
			-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

			dap.adapters.python = function(cb, config)
				if config.request == "attach" then
					---@diagnostic disable-next-line: undefined-field
					local port = (config.connect or config).port
					---@diagnostic disable-next-line: undefined-field
					local host = (config.connect or config).host or "127.0.0.1"
					cb({
						type = "server",
						port = assert(port, "`connect.port` is required for a python `attach` configuration"),
						host = host,
						options = {
							source_filetype = "python",
						},
					})
				else
					cb({
						type = "executable",
						command = "/home/neeladri/.virtualenvs/debugpy/bin/python",
						args = { "-m", "debugpy.adapter" },
						options = {
							source_filetype = "python",
						},
					})
				end
			end
			dap.configurations.python = {
				{
					-- The first three options are required by nvim-dap
					type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
					request = "launch",
					name = "Launch file",

					-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

					program = "${file}", -- This configuration will launch the current file if used.
					pythonPath = function()
						-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
						-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
						-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
						local cwd = vim.fn.getcwd()
						if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
							return cwd .. "/venv/bin/python"
						elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
							return cwd .. "/.venv/bin/python"
						else
							return "/usr/bin/python"
						end
					end,
				},
			}
			dap.adapters["rust-gdb"] = {
				type = "executable",
				command = "rust-gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
			}
			dap.configurations.rust = {
				{
					name = "Launch",
					type = "rust-gdb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					args = {}, -- provide arguments if needed
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
				{
					name = "Select and attach to process",
					type = "rust-gdb",
					request = "attach",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					pid = function()
						local name = vim.fn.input("Executable name (filter): ")
						return require("dap.utils").pick_process({ filter = name })
					end,
					cwd = "${workspaceFolder}",
				},
				{
					name = "Attach to gdbserver :1234",
					type = "rust-gdb",
					request = "attach",
					target = "localhost:1234",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
			}
		end,
	},
	-- { "mfussenegger/nvim-dap-python", enabled = true },
	{
		"stevearc/conform.nvim",
		opts = {
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 100,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				-- You can customize some of the format options for the filetype (:help conform.format)
				rust = { "rustfmt", lsp_format = "fallback" },
				python = { "ruff", "isort" },
				-- Conform will run the first available formatter
				javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},
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
	{
		"OXY2DEV/markview.nvim",
		opts = {
			latex = {
				enable = false,
			},
			preview = {
				callbacks = {
					on_enable = function(_, win)
						vim.wo[win].conceallevel = 2
						-- This will prevent Tree-sitter concealment being disabled on the cmdline mode
						vim.wo[win].concealcursor = "c"
					end,
				},
				hybrid_modes = { "i", "n" },
				modes = { "n", "c", "i" },
			},
		},
	},
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
	-- { "nvim-neorg/neorg", tag = "v7.0.0" },

	-- Utilities
	{
		"hedyhli/outline.nvim",
		config = function()
			-- Example mapping to toggle outline
			vim.keymap.set("n", "<leader>s", "<cmd>Outline<CR>", { desc = "Toggle Outline" })

			require("outline").setup({
				-- Your setup opts here (leave empty to use defaults)
			})
		end,
	},

	{ "tyru/open-browser.vim" },
	{ "zawedcvg/distant.nvim" },
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		lazy = false,
	},
	{ "danymat/neogen", opts = { snippet_engine = "luasnip" } },
	{ "qxxxb/vim-searchhi" },
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
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
	{
		"greggh/claude-code.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim", -- Required for git operations
		},
		config = function()
			require("claude-code").setup({
				window = {
					split_ratio = 0.3,
					position = "vertical",
				},
			})
		end,
	},
}
