local null_ls = require("null-ls")
local formatting = null_ls.builtins.formatting
null_ls.setup({
  sources = {
    formatting.stylua,
    formatting.prettierd,
  },
  on_attach = function(client, bufnr)
    -- if client.supports_method("textDocument/formatting") then
    --   vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    --   vim.api.nvim_create_autocmd("BufWritePre", {
    --     group = augroup,
    --     buffer = bufnr,
    --     callback = function()
    --       -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
    --       -- vim.lsp.buf.formatting_sync()
    --       vim.lsp.buf.format({ bufnr = bufnr })
    --     end,
    --   })
    -- end
  end,
})
