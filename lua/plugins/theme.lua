require("github-theme").setup({
  -- theme_style = "dark_default",
  -- theme_style = "dark_colorblind",
  -- function_style = "italic",
  sidebars = {"qf", "vista_kind", "terminal", "packer"},

  -- Change the "hint" color to the "orange" color, and make the "error" color bright red
  colors = {hint = "orange", error = "#ff0000"},

  -- Overwrite the highlight groups
  overrides = function(c)
    return {
        htmlTag = {fg = c.red, bg = "#282c34", sp = c.hint, style = "underline"},
        DiagnosticHint = {link = "LspDiagnosticsDefaultHint"},
        -- this will remove the highlight groups
        TSField = {},
    }
  end
})

-- vim.o.background = 'dark'
-- vim.cmd([[colorscheme github_dark]])
-- vim.cmd([[colorscheme github_light]])
-- vim.cmd([[colorscheme habamax]])
-- vim.cmd([[colorscheme vscode]])
vim.cmd([[colorscheme gruvbox]])
