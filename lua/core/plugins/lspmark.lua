return {
	"tristone13th/lspmark.nvim",
	main = "lspmark",
	keys = {
		{ "mm", ":lua require('lspmark.bookmarks').toggle_bookmark({with_comment=true})<CR>" },
		{ "ma", ":Telescope lspmark<CR>" },
		{ "md", ":lua require('lspmark.bookmarks').delete_line()<CR>" },
		{ "mp", ":lua require('lspmark.bookmarks').paste_text()<CR>" },
		{ "mi", ":lua require('lspmark.bookmarks').modify_comment()<CR>" },
	},
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
}
