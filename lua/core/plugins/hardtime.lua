return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	event = "BufRead",
	opts = {
		disabled_filetypes = {
			"qf",
			"sagaoutline",
			"minifiles",
			"netrw",
			"NvimTree",
			"lazy",
			"mason",
			"oil",
			"aerial",
			"sagafinder",
			"neo-tree",
			"Avante",
		},
	},
}
