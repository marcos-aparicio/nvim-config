return {
	"MunifTanjim/prettier.nvim",
	"jose-elias-alvarez/null-ls.nvim",
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"williamboman/mason-lspconfig.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
		config = function()
			require("core.plugins.lsp.mason")
			require("core.plugins.lsp.handlers").setup()
			require("core.plugins.lsp.null-ls")
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = {
			"javascript",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		config = function()
			require("typescript-tools").setup({
				filetypes = {
					"javascript",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
			})
		end,
	},
}
