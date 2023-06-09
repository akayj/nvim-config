-- Run gofmt + goimport on save
-- local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.go",
--   callback = function()
--     require('go.format').goimport()
--   end,
--   group = format_sync_grp,
-- })


-- Run gofmt + goimport on save

local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
   require('go.format').goimport()
  end,
  group = format_sync_grp,
})


require('go').setup({
    lsp_inlay_hints = { enable = true },

    lsp_cfg = false,
})

local cfg = require("go.lsp").config()
require('lspconfig').gopls.setup(cfg)
