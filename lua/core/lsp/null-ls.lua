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
		formatting.prettierd,
		formatting.black,
		formatting.sql_formatter,
		formatting.pretty_php,
		formatting.astyle,
	}
end

local formatting_activated = true

function ToggleFormatting()
	formatting_activated = not formatting_activated
	if formatting_activated then
		print("Auto Formatting enabled")
		return
	end
	print("Auto Formatting disabled")
end

vim.cmd([[command! ToggleFormatting lua ToggleFormatting()]])
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
