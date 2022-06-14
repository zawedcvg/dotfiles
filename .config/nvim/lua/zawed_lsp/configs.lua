local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
    return
end

local lspconfig = require("lspconfig")

local servers = { "jsonls", "sumneko_lua", "pyright", "tsserver", "rust-analyzer"}

lsp_installer.setup {
    ensure_installed = servers
}

for _, server in pairs(servers) do
    local opts = {
        on_attach = require("zawed_lsp.handlers").on_attach,
        capabilities = require("zawed_lsp.handlers").capabilities,
    }
    lspconfig[server].setup(opts)
end

--local capabilities = vim.lsp.protocol.make_client_capabilities()
--lspconfig.rust_analyzer.setup {
  --capabilities = capabilities,
  --settings = {
    --["rust-analyzer"] = {
      ---- cargo = { loadOutDirsFromCheck = true },
      ---- procMacro = { enable = true },
      ---- hoverActions = { references = true },
    --},
  --},
--}

-- rust-tools config: https://github.com/simrat39/rust-tools.nvim
-- @TODOUA: selects on *abbles require manual close with no select
-- ... not handling nil in select telescope or otherwise
require("rust-tools").setup {
  tools = {
    inlay_hints = {
      -- prefix for parameter hints
      parameter_hints_prefix = " ",

      -- prefix for all the other hints (type, chaining)
      other_hints_prefix = " ",
    },
  },
}

