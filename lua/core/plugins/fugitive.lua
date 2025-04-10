return {
	"tpope/vim-fugitive",
	lazy = false,
	keys = {
		{ "<leader>ga", ":G add<space>" },
		{ "<leader>go", ":G open<CR>" }, -- custom command of mine
		{ "<leader>gw", ":Gwrite<CR>" },
		{ "<leader>gc", ":G commit<CR>" },
		{ "<leader>gu", ":G reset %<CR>" },
		{ "<leader>gl", ":vertical G log -n 300<CR>" },
		{ "<leader>gps", ":G push<space>" },
		{ "<leader>gpl", ":G pull origin<space>" },
		{ "<leader>gnb", ':G checkout -b ""<left>' },
		{ "<leader>gr", ":G rebase -i HEAD~" },
		{ "<leader>gk", ":G checkout -- %" },
		{ "<leader>gw", ":diffput<CR>", mode = "v" },
		{ "<leader>gh", ":0G log -n 300<CR>", ft = "git", desc = "Open git log in the current buffer" },
	},
	cmd = { "G" },
}
