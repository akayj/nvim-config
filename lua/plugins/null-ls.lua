local null_ls_available, null_ls = pcall(require, "null-ls")
if not null_ls_available then
    print("null-ls is not available")
    return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
    debug = false,
    sources = {
        formatting.prettier.with {
            extra_filetypes = { "toml", "solidity" },
            extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
        },
        formatting.black.with { extra_args = {"--fast"} },
        formatting.stylua,
        formatting.shfmt,
        formatting.rustfmt,
        formatting.google_java_format,

        diagnostics.shellcheck,
    },
}

-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
--
-- null_ls.setup({
--     on_attach = function(client, bufnr)
--         if client.supports_method("textDocument/formatting") then
--             vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--             vim.api.nvim_create_autocmd("BufWritePre", {
--                 group = augroup,
--                 buffer = bufnr,
--                 callback = function()
--                     vim.lsp.buf.format({ async = false })
--                 end,
--             })
--         end
--     end,
-- })
