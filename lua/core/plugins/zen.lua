return {
	"pocco81/true-zen.nvim",
	keys = {
		{ "<leader>zn", ":TZNarrow<CR>", mode = { "n", "v" } },
		{ "<leader>zf", ":TZFocus<CR>" },
		{ "<leader>zm", ":TZMinimalist<CR>" },
		{ "<leader>za", ":TZAtaraxis<CR>" },
	},
	opts = {
		integrations = {
			tmux = true,
		},
	},
}
