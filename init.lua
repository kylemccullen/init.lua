require('kmccullen.functions')

local vim = vim
local Plug = vim.fn['plug#']

vim.g.mapleader = " "

vim.api.nvim_command('filetype plugin on')

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.wrap = false

vim.opt.fixendofline = false

vim.opt.mouse = ''
vim.opt.clipboard = 'unnamedplus'

vim.keymap.set('n', 'Y', 'y$')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

vim.keymap.set('n', '<A-j>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==')
vim.keymap.set('v', '<A-j>', ':m \'>+1<CR>gv=gv')
vim.keymap.set('v', '<A-k>', ':m \'<-2<CR>gv=gv')

vim.keymap.set('x', '<leader>p', '"_dP')

vim.call('plug#begin')

Plug('ellisonleao/gruvbox.nvim')
Plug('vim-airline/vim-airline')
Plug('vim-airline/vim-airline-themes')

Plug('tpope/vim-fugitive')
Plug('mhinz/vim-signify')

Plug('preservim/nerdtree')

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')

Plug('nvim-treesitter/nvim-treesitter')

Plug('preservim/nerdcommenter')

vim.call('plug#end')

vim.api.nvim_set_keymap('n', '<leader>t', ':lua toggle_terminal()<CR>', { noremap = true, silent = true })