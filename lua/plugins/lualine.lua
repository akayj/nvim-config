-- local custom_gruvbox = require'lualine.themes.github-theme'

-- custom_gruvbox.normal.c.bg = '#112233'

require('lualine').setup({
  options = {
    theme = 'vscode',
    fmt = string.lower
  },

  sections = {
    lualine_a = {
      { 'mode', fmt = function(str) return str:sub(1, 1) end },
      -- { 'fileformat', symbols = { unix = '', dos = '', mac = '' } },
      'filetype',
    },

    lualine_b = { 'branch', 'diff' },

    lualine_c = {
      'filename',
      'data', "require'lsp-status'.status()"
    },

    lualine_x = {'encoding', 'fileformat'},
  }
})
