local opt = vim.opt

opt.number = true

opt.tabstop = 4
opt.softtabstop=4
opt.shiftwidth = 4
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
vim.o.background = "light"
-- vim.o.background = "dark"
-- vim.cmd[[colorscheme gruvbox]]

-- Figure out the system Python for Neovim.
vim.cmd([[
  if exists("$VIRTUAL_ENV")
      let g:python3_host_prog=substitute(system("which -a python3 | head -n1"), "\n", '', 'g')
  else
      let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
  endif
]])

vim.cmd [[autocmd BufWritePre *.py :Yapf]]

vim.cmd [[
    autocmd FileType python set shiftwidth=4
    autocmd FileType python set tabstop=4
    autocmd FileType python set softtabstop=4
]]
