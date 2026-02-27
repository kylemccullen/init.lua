local harpoon = require("harpoon")

local function open_claude_term()
    local term_list = harpoon:list("term")
    local term_item = term_list:get(2)
    if term_item == nil or term_item.value == "" then
        vim.cmd("terminal")
        term_list:replace_at(2)
    else
        term_list:select(2)
    end
end

-- Open terminal 2 and run claude (used by dev/wt scripts on startup)
vim.api.nvim_create_user_command('OpenClaude', function()
    vim.schedule(function()
        open_claude_term()
        local term_buf = vim.api.nvim_get_current_buf()
        vim.defer_fn(function()
            local job_id = vim.api.nvim_buf_get_var(term_buf, 'terminal_job_id')
            vim.fn.chansend(job_id, 'claude\n')
        end, 1000)
    end)
end, {})
