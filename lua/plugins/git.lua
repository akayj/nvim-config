local bar_icon = '▌'

require('gitsigns').setup({
    signs = {
        add = { text = bar_icon },
        change = { text = bar_icon },
        delete = { text = bar_icon },
        topdelete = { text = bar_icon },
        changedelete = { text = bar_icon },
        untracked = { text = bar_icon },
    },

    preview_config = { border = 'rounded' },
})
