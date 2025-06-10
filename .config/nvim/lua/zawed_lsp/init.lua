local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end
require("zawed_lsp.configs")
--require("zawed_lsp.cmp")
require("zawed_lsp.handlers").setup()
