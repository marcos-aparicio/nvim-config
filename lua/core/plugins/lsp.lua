return {
	"MunifTanjim/prettier.nvim",
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
			"folke/neodev.nvim",
		},
		config = function()
			require("neodev").setup()
			require("core.lsp.mason")
			require("core.lsp.handlers").setup()
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
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		-- optionally, override the default options:
		config = function()
			require("tailwindcss-colorizer-cmp").setup({
				color_square_width = 2,
			})
		end,
	},
}
