require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site'
}

require('nvim-treesitter').install { 'javascript', 'typescript', 'tsx', 'c_sharp', 'ruby', 'html', 'css' }

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'typescriptreact', 'cs', 'ruby', 'html', 'css' },
  callback = function() vim.treesitter.start() end,
})
