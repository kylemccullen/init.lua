local harpoon = require("harpoon")
harpoon:setup()

local terminals = {}

local function toggle_term(term_id)
    local bufnr = terminals[term_id]

    if bufnr == nil or not vim.api.nvim_buf_is_valid(bufnr) then
        vim.cmd("terminal")
        terminals[term_id] = vim.api.nvim_get_current_buf()
        vim.cmd("startinsert")
    else
        local wins = vim.fn.win_findbuf(bufnr)
        if #wins > 0 then
            vim.api.nvim_set_current_win(wins[1])
        else
            vim.api.nvim_set_current_buf(bufnr)
        end
    end
end

-- Allow other files to register a buffer into a terminal slot
_G.register_harpoon_term = function(id, bufnr)
    terminals[id] = bufnr
end

-- Setup keymaps
vim.keymap.set("n", "<leader>th", function() toggle_term(1) end, { desc = "Terminal 1" })
vim.keymap.set("n", "<leader>tj", function() toggle_term(2) end, { desc = "Terminal 2" })
vim.keymap.set("n", "<leader>tk", function() toggle_term(3) end, { desc = "Terminal 3" })
vim.keymap.set("n", "<leader>tl", function() toggle_term(4) end, { desc = "Terminal 4" })
