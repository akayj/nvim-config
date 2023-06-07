local ts_config = require("nvim-treesitter.configs")
local ensure_installed = {
    "bash",
    "c",
    "css",
    "scss",
    "cpp",
    "dockerfile",
    "javascript",
    "json",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "html",
    "htmldjango",
    "tsx",
    "typescript",
    "vue",
    "vim",
    "vimdoc",
    "yaml",
    "toml",
    "rust",
    "go",
    "gomod",
    "gosum",
    "python",
    "proto",
}

local opts = {
    highlight = {
        enable = true,
    },
    ensure_installed = ensure_installed,
    incremental_selection = {
        enable = false,
        keymaps = {
            init_selection = '<cr>',
            node_incremental = '<cr>',
            node_decremental = '<cr>',
            scope_incremental = '<cr>',
        }
    },

    indent = {
        enable = true
    },
}

ts_config.setup(opts)
