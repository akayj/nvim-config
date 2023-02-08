local opt = vim.opt

opt.number = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

opt.cursorline = true

opt.mouse:append("a")

opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.signcolumn = "yes"

-- vim.cmd[[colorscheme tokyonight-moon]]
-- vim.o.background = "light"
require('gruvbox').setup({
  -- palette_overrides = {
  --   bright_green = '#990000',
  -- }
  -- overrides = {
  --   SignColumn = {bg = "#ff9900"}
  -- }
})
vim.o.background = "dark"
vim.cmd[[colorscheme gruvbox]]
