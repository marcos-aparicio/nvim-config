vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

vim.api.nvim_create_user_command("ToggleFormatting", function()
	vim.b.disable_autoformat = not vim.b.disable_autoformat
	vim.g.disable_autoformat = not vim.g.disable_autoformat
end, {
	desc = "Re-enable autoformat-on-save",
})

return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = function()
			local conform = require("conform")

			vim.keymap.set({ "n", "v" }, "<leader>mp", function()
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
				print("formatting applied")
			end, { desc = "Format file or range (in visual mode)" })
			return {
				formatters_by_ft = {
					python = { "isort", "black" },
					javascript = { "prettier" },
					typescript = { "prettierd" },
					javascriptreact = { "prettier" },
					-- blade = { "blade-formatter", "prettierd", "prettier" },
					blade = { "pretty-php" },
					typescriptreact = { "prettierd" },
					svelte = { "prettierd" },
					css = { "prettierd" },
					html = { "prettier" },
					json = { "prettierd" },
					yaml = { "prettierd" },
					-- markdown = { "prettierd" },
					graphql = { "prettierd" },
					lua = { "stylua" },
					php = { "pretty-php" },
				},
				format_on_save = function()
					return {
						lsp_fallback = true,
						async = false,
						timeout_ms = 1000,
					}
				end,
			}
		end,
	},
}
