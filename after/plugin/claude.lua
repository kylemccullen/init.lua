-- Open terminal 2 and run claude (used by dev/wt scripts on startup)
vim.api.nvim_create_user_command('OpenClaude', function()
    vim.schedule(function()
        vim.cmd("terminal")
        local term_buf = vim.api.nvim_get_current_buf()
        if _G.register_harpoon_term then
            _G.register_harpoon_term(2, term_buf)
        end
        vim.defer_fn(function()
            local job_id = vim.api.nvim_buf_get_var(term_buf, 'terminal_job_id')
            vim.fn.chansend(job_id, 'claude\n')
        end, 1000)
    end)
end, {})
