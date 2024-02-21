local ok, null_ls = pcall(require, "null-ls")
if not ok then
	return
end
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local source_ok, sources = pcall(require, "private.plugins.formatting")
if not source_ok then
	sources = {
		formatting.stylua,
		formatting.prettier,
		formatting.black,
		formatting.sql_formatter,
		formatting.pretty_php,
		formatting.astyle,
	}
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = sources,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					-- vim.lsp.buf.formatting_sync()
					if formatting_activated then
						vim.lsp.buf.format({ bufnr = bufnr })
					end
				end,
			})
		end
	end,
})
