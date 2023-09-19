require('kmccullen')

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

require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use({
        'ellisonleao/gruvbox.nvim',
        as = 'gruvbox',
        config = function()
            vim.cmd('colorscheme gruvbox')
        end
    })

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    use('tpope/vim-fugitive')
    use('mhinz/vim-signify')
    use({
    'kylemccullen/vim-gitstatus',
    config = function()
        vim.keymap.set('n', '<leader>gs', vim.cmd.GitStatus)
    end
    })

    use('preservim/nerdtree')

    use('preservim/nerdcommenter')

    use('vim-airline/vim-airline')
    use('vim-airline/vim-airline-themes')

    use('ThePrimeagen/harpoon')

    use {
    'windwp/nvim-autopairs',
    config = function() require('nvim-autopairs').setup {} end
    }

    use('neovim/nvim-lspconfig')

    use('hrsh7th/nvim-cmp')
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-path')
    use('saadparwaiz1/cmp_luasnip')
    use('hrsh7th/cmp-nvim-lsp')
    use('hrsh7th/cmp-nvim-lua')

    use('jose-elias-alvarez/null-ls.nvim')
    use('MunifTanjim/prettier.nvim')

    use('ryanoasis/vim-devicons')
    use('tiagofumo/vim-nerdtree-syntax-highlight')

    use('wsdjeg/vim-fetch')
end)
