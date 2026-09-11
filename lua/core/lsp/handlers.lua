local M = {}
local navic

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false, -- disable virtual text
    signs = {
      active = signs, -- show signs
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.buf.hover
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.buf.signature_help
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<leader>lsr", ":LspRestart<CR>", opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  -- Deferred require: binding the function directly pulled all of telescope in
  -- on the first LSP attach, which happens on the first buffer read.
  vim.keymap.set("n", "<leader>gr", function()
    require("telescope.builtin").lsp_references()
  end, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1, float = true })
  end, {})
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1, float = true })
  end, {})
  vim.keymap.set("n", "[a", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, {})
  vim.keymap.set("n", "]a", function()
    vim.diagnostic.jump({ count = 1, float = true })
  end, {})
  vim.keymap.set("n", "[w", function()
    vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = -1, float = true })
  end, {})
  vim.keymap.set("n", "]w", function()
    vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = 1, float = true })
  end, {})
  vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.keymap.set(
    "n",
    "gk",
    ':lua vim.diagnostic.open_float(0, { scope = "line", border = "rounded" })<CR>'
  )
end

M.on_attach = function(client, bufnr)
  if client.server_capabilities.documentSymbolProvider then
    -- Required here rather than at module scope so navic loads only once a
    -- symbol-capable server actually attaches.
    navic = navic or require("nvim-navic")
    navic.attach(client, bufnr)
  end
  -- keymaps handled globally via the LspAttach autocmd below, so they apply
  -- to every client (mason-managed and otherwise, e.g. kulala's LSP)
end

-- Fires for every LSP client that attaches to any buffer, regardless of how
-- the server was started (mason, lspconfig, or in-process servers like kulala).
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
  callback = function(args)
    lsp_keymaps(args.buf)
  end,
})

return M
