local vim = vim
local Plug = vim.fn['plug#']

vim.g.mapleader = " "

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

vim.keymap.set("t", "<C-Space>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<C-\\>", "<Nop>", { desc = "Disabled - use Ctrl+Space" })

vim.call('plug#begin')

Plug('Mofiqul/vscode.nvim')
Plug('nvim-lualine/lualine.nvim')

Plug('nvim-tree/nvim-tree.lua')
Plug('nvim-tree/nvim-web-devicons')

Plug('tpope/vim-fugitive')
Plug('mhinz/vim-signify')

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')

Plug('nvim-treesitter/nvim-treesitter')

Plug('preservim/nerdcommenter')

Plug('szw/vim-maximizer')

Plug('ThePrimeagen/harpoon', { branch = 'harpoon2' })

vim.call('plug#end')

vim.api.nvim_create_user_command('Wt', function(opts)
    local branch = opts.args
    if branch == '' then
        print('Usage: :Wt <branch-name>')
        return
    end
    -- Source the wt function and call it
    vim.fn.system('bash -c "source ~/.config/nvim/scripts/wt.sh && wt ' .. vim.fn.shellescape(branch) .. '"')
end, { nargs = 1 })
