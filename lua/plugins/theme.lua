-- require("catppuccin").setup({
--   color_overrides = {
--     all = {
--       text = '#ffffff',
--     },
--     latte = {
--       base = "#ff0000",
--       mantle = "#242424",
--       crust = "#474747",
--     },
--   }
-- })

-- require("github-theme").setup({
--   theme_style = "dark",
--   function_style = "italic",
--   sidebars = {"qf", "vista_kind", "terminal", "packer"},
--
--   -- Change the "hint" color to the "orange" color, and make the "error" color bright red
--   colors = {hint = "orange", error = "#ff0000"},
--
--   -- Overwrite the highlight groups
--   overrides = function(c)
--     return {
--       htmlTag = {fg = c.red, bg = "#282c34", sp = c.hint, style = "underline"},
--       DiagnosticHint = {link = "LspDiagnosticsDefaultHint"},
--       -- this will remove the highlight groups
--       TSField = {},
--     }
--   end
-- })

vim.o.background = 'dark'
vim.cmd([[color gruvbox]])

-- setup must be called before loading
-- vim.cmd.colorscheme "catppuccin"
