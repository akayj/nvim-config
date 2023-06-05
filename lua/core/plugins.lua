local ensure_packer = function()
    local fn =vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

-- vim.cmd([[
-- augroup packer_user_config
-- autocmd!
-- " autocmd BufWritePost plugins.lua source <afile> | PackerSync
-- augroup end
-- ]])

return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")

    -- use 'folke/tokyonight.nvim'
    -- use { "ellisonleao/gruvbox.nvim" }
    use 'Mofiqul/vscode.nvim'
    use({
        "projekt0n/github-nvim-theme",
        tag = "v0.0.7",
        -- config = function()
        --     require('github-theme').setup({})
        --     -- vim.cmd('colorscheme github_light')
        -- end
    })

    -- use { "ellisonleao/gruvbox.nvim" }

    -- use 'Mofiqul/adwaita.nvim'

    use({
        "glepnir/dashboard-nvim",
        event = "VimEnter",
        config = function()
            require("dashboard").setup({})
        end,
        requires = { "nvim-tree/nvim-web-devicons" },
    })

    -- using packer.nvim
    use({ "akinsho/bufferline.nvim", tag = "v3.*", requires = "nvim-tree/nvim-web-devicons" })

    use({
        "nvim-lualine/lualine.nvim",
        -- requires = { "kyazdani42/nvim-web-devicons", opt = true },
        requires = { "nvim-tree/nvim-web-devicons", opt = true },
    })

    use("famiu/bufdelete.nvim")
    use("lukas-reineke/indent-blankline.nvim")

    use({
        "hrsh7th/nvim-cmp",
        requires = {
            -- 'neovim/nvim-lspconfig',
            -- 'hrsh7th/cmp-nvim-lsp',
            -- 'L3MON4D3/LuaSnip',
            -- 'saadparwaiz1/cmp_luasnip',
            -- 'hrsh7th/cmp-buffer',

            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",

            -- For luasnip users.
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",

            -- "octaltree/cmp-look",
            -- "tzachar/cmp-tabnine"
        },
    })

    use("simrat39/inlay-hints.nvim")
    -- use { 'shurizzle/inlay-hints.nvim' }
    -- use 'lvimuser/lsp-inlayhints.nvim'

    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
    })

    use({
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            vim.g.startuptime_tries = 10
        end,
    })

    use({
        "nvim-tree/nvim-tree.lua",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- optional, for file icons
            "MunifTanjim/nui.nvim",
        },
        tag = "nightly", -- optional, updated every week. (see issue #1193)
    })

    use("nvim-tree/nvim-web-devicons")
    use({ "romgrk/barbar.nvim", requires = "nvim-web-devicons" })

    use({
        "lewis6991/gitsigns.nvim",
        -- tag = 'release' -- To use the latest release (do not use this if you run Neovim nightly or dev builds!)
    })

    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()

            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")

            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done)
        end,
    })

    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    use({
        "williamboman/mason.nvim",
    })

    use {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local nls = require('null-ls')
            nls.setup({
                sources = {
                    nls.builtins.formatting.stylua,
                    -- nls.builtins.formatting.lua_format,
                    nls.builtins.formatting.shfmt,
                    nls.builtins.formatting.hclfmt,
                    nls.builtins.formatting.prettierd,
                    nls.builtins.formatting.rustfmt,
                },
            })
        end,
    }

    use({
        "neovim/nvim-lspconfig",
        requires = "nvim-lua/lsp-status.nvim",
        config = function()
            require("lsp-status").register_progress()
        end,
    })
    -- Configurations for Nvim LSP

    use("ray-x/go.nvim")
    use("ray-x/guihua.lua") -- recommended if need floating window support
    use("nvim-treesitter/nvim-treesitter")

    use({ "simrat39/rust-tools.nvim", requires = "neovim/nvim-lspconfig" })

    -- Debugging
    use("nvim-lua/plenary.nvim")
    use("mfussenegger/nvim-dap")
    use({
        "theHamsta/nvim-dap-virtual-text",
        config = function()
            require("nvim-dap-virtual-text").setup()
        end
    })

    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.x",
        -- or                            , branch = '0.1.x',
        -- event = "VimEnter",
        requires = { { "nvim-lua/plenary.nvim" } },
    })

    use({
        "akayj/yapf.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("yapf").setup({})
        end,
    })

    -- use {
    --     'stsewd/isort.nvim',
    -- }

    use({
        "sansyrox/vim-python-virtualenv",
        config = function()
            vim.cmd([[
                let g:python_host_prog='.venv/bin/python'
                let g:python3_host_prog='.venv/bin/python3'
            ]])
        end,
    })

    -- TODO: use this latter
    -- use {
    --     'sbdchd/neoformat',
    -- }

    use({
        "cuducos/yaml.nvim",
        ft = { "yaml" }, -- optional
        requires = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-telescope/telescope.nvim", -- optional
        },
    })

    use({
        "saecki/crates.nvim",
        -- tag = 'v0.3.0',
        event = { "BufRead Cargo.toml" },
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("crates").setup()
        end,
    })

    use({ "raimon49/requirements.txt.vim", event = { "BufRead *requirements.txt" } })

    use({
        "ckipp01/stylua-nvim",
        run = "cargo install stylua",
        config = function()
            require("stylua-nvim").setup()
        end,
    })

    use({
        "stevearc/aerial.nvim",
        config = function()
            require("aerial").setup()
        end,
    })

    use({
        "norcalli/nvim-colorizer.lua",
    })

    use({
        'dcampos/nvim-snippy',
        requires = {
            'honza/vim-snippets',
        },
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
