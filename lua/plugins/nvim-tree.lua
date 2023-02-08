vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('nvim-tree').setup({
  default_component_configs = {
    window = {
      filesystem = {
        filtered_items = {
          hide_gitignored = false,
        },
      }
    }
  }
})
