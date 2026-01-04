local status_ok1, mason = pcall(require, "mason")
local status_ok, lsp_installer = pcall(require, "mason-lspconfig")
--local status_ok2, null_ls = pcall(require, "null-ls")

local navic = require("nvim-navic")
if not status_ok then
	return
end

local on_attach = function(client, bufnr)
	require("zawed_lsp.handlers").on_attach(client, bufnr)
	navic.attach(client, bufnr)
end

--local formatting = null_ls.builtins.formatting

local lspconfig = require("lspconfig")

local servers = { "jsonls", "ts_ls", "clangd" }
-- local servers = { "jsonls", "ts_ls"}
--

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
		},
	},
})

lsp_installer.setup({
	ensure_installed = servers,
	automatic_installation = false,
	automatic_setup = false,
	automatic_enable = false,
	handlers = {
		-- Default handler for servers in the 'servers' list
		function(server_name)
			local opts = {
				on_attach = on_attach,
				capabilities = require("zawed_lsp.handlers").capabilities,
			}
			lspconfig[server_name].setup(opts)
		end,
		-- Explicitly disable automatic setup for pyright (we configure it manually below)
		["pyright"] = function() end,
	},
})

lspconfig.gopls.setup({
	on_attach = on_attach,
	capabilities = require("zawed_lsp.handlers").capabilities,
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
			},
		},
	},
})

require("lspconfig").pyright.setup({
	on_attach = on_attach,
	capabilities = require("zawed_lsp.handlers").capabilities,
	single_file_support = false, -- Prevent starting for single files outside projects
	root_dir = require("lspconfig.util").root_pattern("pyproject.toml", "setup.py", ".git"),
})

-- rust-tools config: https://github.com/simrat39/rust-tools.nvim
-- @TODOUA: selects on *abbles require manual close with no select
-- ... not handling nil in select telescope or otherwise
require("rust-tools").setup({
	server = {
		on_attach = on_attach,
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	},
	tools = {
		--hover_with_actions = true,
		inlay_hints = {
			-- prefix for parameter hints
			parameter_hints_prefix = "󰅲 ",

			-- prefix for all the other hints (type, chaining)
			other_hints_prefix = " ",
		},
	},
})

require("clangd_extensions").setup({
	server = { on_attach = on_attach },
})

--require("ccls").setup {
--lsp = {
---- check :help vim.lsp.start for config options
--server = {
--name = "ccls", --String name
--cmd = {"/usr/bin/ccls"}, -- point to your binary, has to be a table
--args = {[>Any args table<] },
--offset_encoding = "utf-32", -- default value set by plugin
--root_dir = vim.fs.dirname(vim.fs.find({ "compile_commands.json", ".git" }, { upward = true })[1]), -- or some other function that returns a string
----on_attach = your_func,
----capabilites = your_table/func
--},
--},
--}
--

--require("clangd_extensions").setup()

lspconfig["lua_ls"].setup({
	capabilities = require("zawed_lsp.handlers").capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
