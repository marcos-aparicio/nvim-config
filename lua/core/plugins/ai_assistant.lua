local USE_CODECOMPANION = true -- Set to false to use CopilotChat

if USE_CODECOMPANION then
	return {
		{
			"olimorris/codecompanion.nvim",
			opts = {
				extensions = {
					vectorcode = {
						opts = {
							tool_group = {
								enabled = true,
								extras = {},
								collapse = false,
							},
							tool_opts = {
								["*"] = {},
								ls = {},
								vectorise = {},
								query = {
									max_num = { chunk = -1, document = -1 },
									default_num = { chunk = 50, document = 10 },
									include_stderr = false,
									use_lsp = false,
									no_duplicate = true,
									chunk_mode = false,
									summarise = {
										enabled = false,
										adapter = nil,
										query_augmented = true,
									},
								},
								files_ls = {},
								files_rm = {},
							},
						},
					},
				},
			},
			keys = {
				{ "<leader>ac", ":codecompanionchat toggle<cr>" },
				{ "<leader>aa", ":codecompanionactions <cr>" },
				{ "<leader>ap", ":codecompanion " },
			},
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
			},
		},
	}
else
	return {
		{
			"copilotc-nvim/copilotchat.nvim",
			dependencies = {
				{ "nvim-lua/plenary.nvim", branch = "master" },
			},
			keys = { { "<leader>ac", ":copilotchattoggle<cr>" } },
			build = "make tiktoken",
			opts = {},
		},
	}
end
