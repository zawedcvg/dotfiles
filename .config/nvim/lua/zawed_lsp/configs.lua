local status_ok1, mason = pcall(require, "mason")
if not status_ok1 then
	return
end

local on_attach = function(client, bufnr)
	require("zawed_lsp.handlers").on_attach(client, bufnr)
end

-- Mason still handles installing servers
mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
		},
	},
})

-- Ensure mason-lspconfig installs the servers (but we don't use its handlers for setup)
local status_ok2, mason_lspconfig = pcall(require, "mason-lspconfig")
if status_ok2 then
	mason_lspconfig.setup({
		ensure_installed = { "jsonls", "ts_ls", "clangd", "ty" },
		automatic_installation = false,
		automatic_enable = false,
	})
end

-- Default config applied to all servers
vim.lsp.config("*", {
	on_attach = on_attach,
})

-- Per-server configs using native vim.lsp.config
vim.lsp.config("jsonls", {})

vim.lsp.config("ts_ls", {})

vim.lsp.config("clangd", {})

vim.lsp.config("gopls", {
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

vim.lsp.config("ty", {
	cmd = { "ty", "server" },
	root_markers = { "ty.toml", "pyproject.toml", "setup.py", ".git" },
	single_file_support = false,
})

vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy",
			},
		},
	},
})

vim.lsp.config("lua_ls", {
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

-- Enable all configured servers
vim.lsp.enable({
	"jsonls",
	"ts_ls",
	"clangd",
	"gopls",
	"ty",
	"rust_analyzer",
	"lua_ls",
})

-- clangd_extensions still needs its own setup call
require("clangd_extensions").setup({})
