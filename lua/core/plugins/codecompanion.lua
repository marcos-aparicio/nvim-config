return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		main = "copilot",
		lazy = false,
		event = "InsertEnter",
		config = function()
			require("copilot").setup({})
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		opts = {},
		keys = {
			{ "<leader>ac", ":CodeCompanionChat Toggle<CR>" },
			{ "<leader>aa", ":CodeCompanionActions <CR>" },
			{ "<leader>ap", ":CodeCompanion " },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	-- {
	-- 	"OXY2DEV/markview.nvim",
	-- 	lazy = false,
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	opts = {
	-- 		preview = {
	-- 			filetypes = { "markdown", "codecompanion" },
	-- 			ignore_buftypes = {},
	-- 		},
	-- 	},
	-- },
	{
		"echasnovski/mini.diff",
		config = function()
			local diff = require("mini.diff")
			diff.setup({
				-- Disabled by default
				source = diff.gen_source.none(),
			})
		end,
	},
	{
		"HakonHarnes/img-clip.nvim",
		opts = {
			filetypes = {
				codecompanion = {
					prompt_for_file_name = false,
					template = "[Image]($FILE_PATH)",
					use_absolute_path = true,
				},
			},
		},
	},
}
