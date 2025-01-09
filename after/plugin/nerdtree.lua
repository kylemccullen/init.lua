vim.api.nvim_set_keymap('n', '<leader>f', ':NERDTreeToggle %<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', ':NERDTreeFind<CR>', { noremap = true, silent = true })

vim.g.NERDTreeWinSize = 35