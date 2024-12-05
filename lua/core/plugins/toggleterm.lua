return {
	"akinsho/toggleterm.nvim",
	version = "*",
	-- opts = { --[[ things you want to change go here]]
	-- },
	keys = {
		{ "<C-;>", "<Cmd>ToggleTerm<CR>", mode = { "t", "n" } },
		{ "<leader>lg", "<Cmd>TermExec direction=float cmd=lazygit<CR>", mode = { "t", "n" } },
		{ "<leader>ld", "<Cmd>TermExec direction=float cmd=lazydocker<CR>", mode = { "t", "n" } },
	},
	config = function()
		require("toggleterm").setup({
			-- open_mapping = [[<c-;]],
			autochdir = true,
			shade_terminals = false, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
			highlights = {
				Normal = {
					guibg = "#0a0e14",
				},
			},
		})
	end,
}
