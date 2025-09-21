return {
	"MunifTanjim/prettier.nvim",
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason.nvim",
		},
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			-- where all the magic happens ⬇
			require("core.lsp.mason")
			require("core.lsp.handlers").setup()
			return {}
		end,
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		ft = {
			-- "javascript",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		main = "typescript-tools",
		opts = {
			filetypes = {
				"javascript",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
			},
		},
	},
	{
		"roobert/tailwindcss-colorizer-cmp.nvim",
		main = "tailwindcss-colorizer-cmp",
		-- optionally, override the default options:
		opts = {
			color_square_width = 2,
		},
	},
}
