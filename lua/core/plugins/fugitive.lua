return {
	"tpope/vim-fugitive",
	lazy = false,
	keys = {
		{ "<leader>ga", ":G add<space>" },
		{ "<leader>gw", ":Gwrite<CR>" },
		{ "<leader>gc", ":G commit<CR>" },
		{ "<leader>gu", ":G reset %<CR>" },
		{ "<leader>gl", ":vertical G log<CR>" },
		{ "<leader>gps", ":G push<space>" },
		{ "<leader>gpl", ":G pull origin<space>" },
		{ "<leader>gnb", ':G checkout -b ""<left>' },
		{ "<leader>gr", ":G rebase -i HEAD~" },
		{ "<leader>gk", ":G checkout -- %" },
		{ "<leader>gd", ":vertical G diff % " },
		{ "<leader>gw", ":diffput<CR>", mode = "v" },
	},
	cmd = { "G" },
}
