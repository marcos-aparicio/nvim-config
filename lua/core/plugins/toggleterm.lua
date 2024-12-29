return {
	"akinsho/toggleterm.nvim",
	version = "*",
	main = "toggleterm",
	opts = {
		autochdir = true,
		shade_terminals = false,
		highlights = {
			Normal = {
				guibg = "#0a0e14",
			},
		},
	},
	keys = {
		{ "<C-;>", "<Cmd>ToggleTerm<CR>", mode = { "t", "n" } },
		{ "<leader>lg", "<Cmd>TermExec direction=float cmd=lazygit<CR>", mode = { "t", "n" } },
		{ "<leader>ld", "<Cmd>TermExec direction=float cmd=lazydocker<CR>", mode = { "t", "n" } },
	},
}
