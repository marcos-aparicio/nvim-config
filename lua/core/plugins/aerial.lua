return {
	"stevearc/aerial.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("aerial").setup()
		vim.keymap.set("n", "<leader>aa", "<cmd>AerialToggle<CR>")
		vim.keymap.set("n", "<leader>al", "<cmd>AerialOpen!<CR>")
	end,
}
