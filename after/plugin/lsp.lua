vim.lsp.config('*', {
  root_markers = { '.git' },
})

vim.lsp.enable({
  'ts_ls',
  'omnisharp',
  'ruby_lsp',
  'html',
  'cssls',
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', '[g', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', ']g', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', '<leader>rn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('n', '<leader>ca', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
  end,
})
