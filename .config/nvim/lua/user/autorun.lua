local group = vim.api.nvim_create_augroup("zawed_autorun", { clear = true });
local run_background = function(pattern, command)
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = group,
        pattern = pattern,
        callback = function()
            vim.fn.jobstart(command)
        end,
    })
end
local attach_to_buffer = function(output_bufnr, pattern, command)
    vim.api.nvim_create_autocmd("BufWritePost", {
        group = group,
        pattern = pattern,
        callback = function()
            local append_data = function(_, data)
                if data then
                    vim.api.nvim_buf_set_lines(output_bufnr, -1, -1, false, data)
                end
            end

            vim.api.nvim_buf_set_lines(output_bufnr, 0, -1, false, { "AutoRun: " })

            vim.fn.jobstart(command, {
                stdout_buffered = true,
                on_stdout = append_data,
                on_stderr = append_data
            })
        end,
    })
end

vim.api.nvim_create_user_command("AutoRun", function ()
    print " Auto Run begins"
    local bufnr = vim.fn.input("Bufnr: ")
    local pattern = vim.fn.input("Pattern: ")
    local command = vim.split(vim.fn.input("command: "), " ")
    attach_to_buffer(tonumber(bufnr), pattern, command)
end, {})

vim.api.nvim_create_user_command("RunBg", function ()
    print " Auto Run begins"
    local pattern = vim.fn.input("Pattern: ")
    local command = vim.split(vim.fn.input("command: "), " ")
    run_background(pattern, command)
end, {})
