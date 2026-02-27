-- Normal mode: Toggle maximizer with F3
vim.keymap.set('n', '<F3>', ':MaximizerToggle<CR>', { silent = true, noremap = true })

-- Visual mode: Toggle maximizer with F3 and reselect the previous visual selection
vim.keymap.set('v', '<F3>', ':MaximizerToggle<CR>gv', { silent = true, noremap = true })

-- Insert mode: Use <C-o> to run the command without leaving insert mode
vim.keymap.set('i', '<F3>', '<C-o>:MaximizerToggle<CR>', { silent = true, noremap = true })
