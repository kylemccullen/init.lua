local term = require('harpoon.term')

vim.keymap.set('n', '<leader>tj', function() term.gotoTerminal(0) end)
vim.keymap.set('n', '<leader>tk', function() term.gotoTerminal(1) end)
