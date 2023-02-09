local M = {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[
        set background=dark
      ]])
    end,
  },

  {
    "dstein64/vim-startuptime",
    event = "VeryLazy",
    cmd = "StartupTime",
    config = function() vim.g.startuptime_tries = 10 end
  },

  {
    "preservim/tagbar",
    ft = { "markdown", "go", "lua", "rust" },
    config = function()
      vim.cmd([[
        let g:tagbar_show_tag_count = 1
        let g:tagbar_sort = 0
        let g:tagbar_autopreview = 0
      ]])
    end,
  },

  {
    "danymat/neogen",
    event = "VeryLazy",
    config = function() require("autoclose").setup() end,
  },
}

return M
