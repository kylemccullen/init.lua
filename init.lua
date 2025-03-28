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
Plug('Mofiqul/vscode.nvim')
Plug('nvim-lualine/lualine.nvim')

Plug('tpope/vim-fugitive')
Plug('mhinz/vim-signify')

Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-tree/nvim-web-devicons')

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')

Plug('nvim-treesitter/nvim-treesitter')

Plug('stevearc/oil.nvim')
Plug('preservim/nerdcommenter')
Plug('windwp/nvim-autopairs')

Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')

Plug('jose-elias-alvarez/null-ls.nvim')
Plug('MunifTanjim/prettier.nvim')

Plug('delphinus/vim-firestore')

vim.call('plug#end')

require("nvim-tree").setup()

vim.api.nvim_set_keymap('n', '<leader>t', ':lua toggle_terminal()<CR>', { noremap = true, silent = true })