-- vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
-- vim.opt.listchars:append "eol:↴"
--
-- require("indent_blankline").setup {
--     show_end_of_line = true,
--     space_char_blankline = " ",
-- }

vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

vim.cmd [[
  " highlight ExtraWhitespace ctermbg=red guibg=yellow
  " highlight ExtraWhitespace ctermbg=red guibg=#E06C75

  match ExtraWhitespace /\s\+$/

  " Show trailing whitespace and spaces before a tab:
  " match ExtraWhitespace /\s\+$\| \+\ze\t/

  " Show tabs that are not at the start of a line:
  " match ExtraWhitespace /[^\t]\zs\t\+/

  " Show spaces used for indenting (so you use only tabs for indenting).
  " match ExtraWhitespace /^\t*\zs \+/
]]

vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "tab:>-"
-- vim.opt.listchars:append "eol:↴"

require("indent_blankline").setup {
    space_char_blankline = " ",
    char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
    },
}
