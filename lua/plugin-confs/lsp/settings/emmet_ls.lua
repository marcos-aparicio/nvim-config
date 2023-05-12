-- local lspconfig = require("lspconfig")
-- local configs = require("lspconfig/configs")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
  capabilities = capabilities,
  filetypes = {
    "css",
    "eruby",
    "html",
    "javascript",
    -- "javascriptreact",
    "less",
    "sass",
    "scss",
    "svelte",
    "pug",
    -- "typescriptreact",
    "vue",
  },
}
