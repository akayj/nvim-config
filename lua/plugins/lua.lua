local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map("n", "<leader>f", '<Cmd>lua require("stylua-nvim").format_file()<CR>', opts)
