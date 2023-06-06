local status_ok, mason = pcall(require, "mason")
if not status_ok then
    return
end

local status_ok_1, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok_1 then
    print("mason-lspconfig is missing")
    return
end

local servers = {
    "cssls",
    "html",
    "jsonls",
    "tsserver",
    "yamlls",
    "bashls",
    "rust_analyzer",
    "gopls",
}

mason.setup({
    border = "rounded",
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    },
    max_concurrent_installers = 4,
})

mason_lspconfig.setup {
    ensure_installed = servers,
    automatic_installation = true,
}
