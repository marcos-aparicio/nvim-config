local USE_CODECOMPANION = false -- Set to false to use CopilotChat

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
			cmd = { "CopilotChatToggle", "CopilotChat" },
			keys = {
				{ "<leader>ac", ":CopilotChatToggle<cr>" },
				{ "<leader>a.", ":CopilotChatSave ", mode = "n", ft = "copilot-chat" },
				{
					"<leader>a,",
          ":CopilotChatLoad ",
          ft = "copilot-chat",
					{ desc = "Open CopilotChat History Picker" },
				},
			},
			build = "make tiktoken",
			opts = {
				mappings = {
					show_help = {
						normal = "?",
					},
					reset = {
						normal = "grs",
					},
				},
				prompts = {
					Quickfix = {
						system_prompt = "The user will provide you with some context and instructions and you should respond in an output format that can be interpreted by a quickfix file in the following format per line: <filename>:<column>:<line>:<text> ",
					},
				},
			},
		},
	}
end
