local status_ok1, mason = pcall(require, "mason")
local status_ok, lsp_installer = pcall(require, "mason-lspconfig")
local status_ok2, null_ls = pcall(require, "null-ls")

local navic = require("nvim-navic")
if not status_ok then
    return
end

--local null_ls = require("nvim-navic")
--if not status_ok then
--return
--end

local on_attach = function(client, bufnr)
    require("zawed_lsp.handlers").on_attach(client, bufnr)
    navic.attach(client, bufnr)
end

local formatting = null_ls.builtins.formatting

null_ls.setup({
    --on_init = function(new_client, _)
    --new_client.offset_encoding = 'utf-32'
    --end,
    --sources = {
    --formatting.clang_format.with({
    --extra_args = { "--style", "{IndentWidth: 4 ,ColumnLimit: 120}" },
    --}),
    --}
})


local lspconfig = require("lspconfig")

local servers = { "jsonls", "sumneko_lua", "pyright", "tsserver" }

mason.setup {
    ui = {
        icons = {
            package_installed = "✓"
        }
    }
}

lsp_installer.setup {
    ensure_installed = servers
}


for _, server in pairs(servers) do
    local opts = {
        on_attach = on_attach,
        capabilities = require("zawed_lsp.handlers").capabilities,
    }
    lspconfig[server].setup(opts)
end

-- rust-tools config: https://github.com/simrat39/rust-tools.nvim
-- @TODOUA: selects on *abbles require manual close with no select
-- ... not handling nil in select telescope or otherwise
require("rust-tools").setup {
    server = { on_attach = on_attach,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                }
            }
        } },
    tools = {
        --hover_with_actions = true,
        inlay_hints = {
            -- prefix for parameter hints
            parameter_hints_prefix = " ",

            -- prefix for all the other hints (type, chaining)
            other_hints_prefix = " ",
        },
    },
}

require("clangd_extensions").setup {
    server = { on_attach = on_attach },
}
