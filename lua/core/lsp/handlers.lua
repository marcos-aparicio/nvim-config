local M = {}

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
	local opts = { noremap = true, silent = true }
	vim.keymap.set("n", "<leader>lsr", ":LspRestart<CR>", opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "<leader>gr", require("telescope.builtin").lsp_references, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1, float = true })
	end, {})
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1, float = true })
	end, {})
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.keymap.set("n", "gk", ':lua vim.diagnostic.open_float(0, { scope = "line", border = "rounded" })<CR>')
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
end

return M
