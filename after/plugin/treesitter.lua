require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c_sharp", "json", "typescript", "html", "tsx", "lua"  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}