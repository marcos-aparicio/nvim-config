return {
	"jackMort/ChatGPT.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		api_key_cmd = "pass show personal/api_keys/openai",
	},
	keys = {
		{ "<leader>aiq", ":ChatGPT<CR>" },
		{ "<leader>air", ":ChatGPT run<space>" },
		{ "<leader>aid", ":ChatGPTRun docstring<CR>", mode = "v" },
		{ "<leader>ait", ":ChatGPTRun add_tests<CR>", mode = "v" },
	},
}
