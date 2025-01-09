function toggle_terminal()
    local term_buf = vim.fn.bufnr('term://*')

    if term_buf == -1 then
        vim.cmd('split')
        vim.cmd('wincmd p')
        vim.cmd('resize 18')
        vim.cmd('term')
    else
        local win_id = vim.fn.bufwinid(term_buf)
        
        if win_id ~= -1 then
            vim.api.nvim_win_close(win_id, true)
        else
            vim.cmd('split')
            vim.cmd('wincmd p')
            vim.cmd('resize 18')
            vim.cmd('buffer ' .. term_buf)
        end
    end
end
