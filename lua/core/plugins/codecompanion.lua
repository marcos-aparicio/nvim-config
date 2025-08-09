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
		---@module "vectorcode"
		opts = {
			extensions = {
				vectorcode = {
					---@type VectorCode.CodeCompanion.ExtensionOpts
					opts = {
						tool_group = {
							-- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
							enabled = true,
							-- a list of extra tools that you want to include in `@vectorcode_toolbox`.
							-- if you use @vectorcode_vectorise, it'll be very handy to include
							-- `file_search` here.
							extras = {},
							collapse = false, -- whether the individual tools should be shown in the chat
						},
						tool_opts = {
							---@type VectorCode.CodeCompanion.ToolOpts
							["*"] = {},
							---@type VectorCode.CodeCompanion.LsToolOpts
							ls = {},
							---@type VectorCode.CodeCompanion.VectoriseToolOpts
							vectorise = {},
							---@type VectorCode.CodeCompanion.QueryToolOpts
							query = {
								max_num = { chunk = -1, document = -1 },
								default_num = { chunk = 50, document = 10 },
								include_stderr = false,
								use_lsp = false,
								no_duplicate = true,
								chunk_mode = false,
								---@type VectorCode.CodeCompanion.SummariseOpts
								summarise = {
									---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
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
	{
		"Davidyz/VectorCode",
		version = "*", -- optional, depending on whether you're on nightly or release
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "VectorCode", -- if you're lazy-loading VectorCode
	},
}
