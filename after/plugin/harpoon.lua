local harpoon = require("harpoon")
harpoon:setup()

-- Helper function to create or select a terminal
local function toggle_term(term_id)
    local term_list = harpoon:list("term")
    local term_item = term_list:get(term_id)
    
    if term_item == nil or term_item.value == "" then
        -- Create a new terminal
        vim.cmd("terminal")
        -- Add it to harpoon at the specific position
        term_list:replace_at(term_id)
    else
        -- Select existing terminal
        term_list:select(term_id)
    end
end

-- Setup keymaps
vim.keymap.set("n", "<leader>th", function() toggle_term(1) end, { desc = "Terminal 1" })
vim.keymap.set("n", "<leader>tj", function() toggle_term(2) end, { desc = "Terminal 2" })
vim.keymap.set("n", "<leader>tk", function() toggle_term(3) end, { desc = "Terminal 3" })
vim.keymap.set("n", "<leader>tl", function() toggle_term(4) end, { desc = "Terminal 4" })
