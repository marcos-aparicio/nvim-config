vim.keymap.set({ "n" }, "<leader>ao", ":Lspsaga outline<CR>")
return {
	"nvimdev/lspsaga.nvim",
	event = "LspAttach",
	opts = {
		lightbulb = {
			enable = false,
		},
		outline = {
			layout = "float",
		},
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- optional
		"nvim-tree/nvim-web-devicons", -- optional
	},
}
