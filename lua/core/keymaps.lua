vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("v", "J", ">+1<CR>gv=gv")
keymap.set("v", "K", "<-2<CR>gv=gv")

keymap.set("n", "<leader>sv", "<C-w>v")
keymap.set("n", "<leader>sh", "<C-w>s")

keymap.set("n", "<leader>nh", ":nohl<CR>")

keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

keymap.set("n", "<leader>d", ":bd<CR>")
keymap.set("n", "<leader>q", ":qall<CR>")
