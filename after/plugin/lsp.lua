local cmp = require('cmp')

cmp.setup {
  mapping = {
    ['<C-N>'] = cmp.mapping.select_next_item(),
    ['<C-P>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  },
  sources = {
    { name = 'nvim_lsp' },
  }
}

local function organize_imports()
    local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

require'lspconfig'.tsserver.setup{
    init_options = {
        preferences = {
            importModuleSpecifierPreference = "relative"
        }
    },
    commands = {
        OrganizeImports = {
            organize_imports,
            description = "Organize Imports"
        }
    }
}

require'lspconfig'.lua_ls.setup{}

require'lspconfig'.angularls.setup{}
-- local project_library_path = "C:/Users/kmccullen/AppData/Roaming/npm"
-- local cmd = {"ngserver", "--stdio", "--tsProbeLocations", project_library_path , "--ngProbeLocations", project_library_path}

-- require'lspconfig'.angularls.setup{
  -- cmd = cmd,
  -- on_new_config = function(new_config,new_root_dir)
    -- new_config.cmd = cmd
  -- end,
-- }

require'lspconfig'.omnisharp.setup{
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = function(client, bufnr)
        if client.name == "omnisharp" then
            client.server_capabilities.semanticTokensProvider.legend = {
                tokenModifiers = { "static" },
                tokenTypes = { "comment", "excluded", "identifier", "keyword", "keyword", "number", "operator", "operator", "preprocessor", "string", "whitespace", "text", "static", "preprocessor", "punctuation", "string", "string", "class", "delegate", "enum", "interface", "module", "struct", "typeParameter", "field", "enumMember", "constant", "local", "parameter", "method", "method", "property", "event", "namespace", "label", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "xml", "regexp", "regexp", "regexp", "regexp", "regexp", "regexp", "regexp", "regexp", "regexp" }
            }
        end
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    end,
    cmd = { "C:/omnisharp-win-x64/OmniSharp.exe", "--languageserver" , "--hostPID", tostring(pid) },
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }

    vim.keymap.set('n', '[g', function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set('n', ']g', function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', function() vim.lsp.buf.references() end, opts)
    vim.keymap.set('n', 'rn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('n', 'rn', function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set('n', 'ca', function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, opts)
  end,
})
