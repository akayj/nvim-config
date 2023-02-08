-- vim.o.background = 'dark'
-- -- vim.o.background = 'light'
--
-- local c = require('vscode.colors').get_colors()
-- require('vscode').setup({
--   transparent = true,
--   italic_comments = true,
--   disable_nvimtree_bg = true,
--
--   color_overrides = {
--     vsLineNumber = '#FFFFFF'
--   },
--
--   -- Override highlight groups (see ./lua/vscode/theme.lua)
--   group_overrides = {
--     -- this supports the same val table as vim.api.nvim_set_hl
--     -- use colors from this colorscheme by requiring vscode.colors!
--     Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
--   }
-- })

require("catppuccin").setup({
    -- flavour = "mocha", -- latte, frappe, macchiato, mocha
    -- background = { -- :h background
    --     light = "latte",
    --     dark = "mocha",
    -- },
  color_overrides = {
    all = {
      text = '#ffffff',
    },
    latte = {
      base = "#ff0000",
      mantle = "#242424",
      crust = "#474747",
    },
  }
})

-- setup must be called before loading
vim.cmd.colorscheme "catppuccin"
