local M = {}

-- TODO: backfill this to template
M.setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    local config = {
        -- disable virtual text
        virtual_text = { only_current_line = true },
        -- show signs
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = { only_current_line = true },
            underline = true,
            update_in_insert = false,
            signs = true,
        }
    )
end

--function loca()
--local new_name = 3
--print(new_name)
--end

--{
--documentChanges = { {
--edits = { {
--_index = 1,
--newText = "some",
--range = {
--end = {
--character = 14,
--line = 34
--},
--start = {
--character = 8,
--line = 34
--}
--}
--}, {
--_index = 2,
--newText = "some",
--range = {
--end = {
--character = 14,
--line = 40
--},
--start = {
--character = 8,
--line = 40
--}
--}
--} },
--textDocument = {
--uri = "file:///home/neeladri/google_download_rust/src/main.rs",
--version = 0
--}
--} }
--}
function global()
    local position_params = vim.lsp.util.make_position_params()
    local new_name = vim.fn.input "New Name > "
    position_params.newName = new_name
    vim.lsp.buf_request(0, "textDocument/rename", position_params, function(err, method, result, ...)
        vim.lsp.handlers["textDocument/rename"](err, method, result, ...)
        local entries = {}
        if method.changes then
            for uri, edits in pairs(method.changes) do
                local bufnr = vim.uri_to_bufnr(uri)

                for _, edit in ipairs(edits) do
                    local start_line = edit.range.start.line + 1
                    local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]

                    table.insert(entries, {
                        bufnr = bufnr,
                        lnum = start_line,
                        col = edit.range.start.character + 1,
                        text = line,
                    })
                end
            end
        end

        if method.documentChanges then
            for _, doc_edits in ipairs(method.documentChanges) do
                print(vim.inspect(doc_edits))
                edits = doc_edits["edits"]
                text_doc = doc_edits["textDocument"]
                print(vim.inspect(edits))
                print(vim.inspect(text_doc))
                local bufnr = vim.uri_to_bufnr(text_doc.uri)
                for _, edit in ipairs(edits) do
                    local start_line = edit.range.start.line + 1
                    local line = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, start_line, false)[1]
                    table.insert(entries, {
                        bufnr = bufnr,
                        lnum = start_line,
                        col = edit.range.start.character + 1,
                        text = line,
                    })
                end
            end
        end

        print(vim.inspect(entries))
        vim.fn.setqflist(entries, "r")
    end)
end

M.renameqf = global

local function lsp_highlight_document(client)
    -- Set autocommands conditional on server_capabilities
    local status_ok, illuminate = pcall(require, "illuminate")
    if not status_ok then
        return
    end
    illuminate.on_attach(client)
    -- end
end


local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    --vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "[g", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "gl",
        '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
        opts
    )
    vim.api.nvim_buf_set_keymap(bufnr, "n", "]g", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    --vim.cmd [[ command! Format execute 'lua require('conform').format())' ]]
end

M.on_attach = function(client, bufnr)
    -- vim.notify(client.name .. " starting...")
    -- TODO: refactor this into a method that checks if string in list

    --if client.name == "tsserver" then
    --client.resolved_capabilities.document_formatting = false
    --end
    --if client.name == "clangd" then
    ----client.resolved_capabilities.document_formatting = false
    ----client.resolved_capabilities.offsetEncoding = {"utf-16"}
    --end
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
