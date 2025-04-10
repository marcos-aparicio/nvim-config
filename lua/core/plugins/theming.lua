return {
	"Shatur/neovim-ayu",
	priority = 1000,
	event = "VeryLazy",
	main = "ayu",
	opts = {
		mirage = false,
		overrides = {
			Normal = { bg = "None" },
			NormalFloat = { bg = "none" },
			Winbar = { bg = "none" },
			ColorColumn = { bg = "None" },
			TabLineFill = { bg = "None" },
			SignColumn = { bg = "None" },
			Folded = { bg = "None" },
			FoldColumn = { bg = "None" },
			CursorLine = { bg = "None" },
			CursorColumn = { bg = "None" },
			VertSplit = { bg = "None" },
			LineNr = { fg = "#FFD580" },
			LineNrAbove = { fg = "#606366" },
			LineNrBelow = { fg = "#606366" },
		},
	},
	init = function()
		vim.opt.syntax = "on"
		vim.o.termguicolors = true
		vim.g.Powerline_symbols = "fancy"
		vim.g.ayucolor = "dark"
		vim.cmd([[ colorscheme default ]])
		require("ayu").colorscheme()
	end,
}
