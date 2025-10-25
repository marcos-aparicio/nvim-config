return {
	"marcos-aparicio/lspmark.nvim",
	keys = {
		{ "mm", ":lua require('lspmark.bookmarks').toggle_bookmark({with_comment=true})<CR>" },
		{ "ma", ":Telescope lspmark current_file_only=true<CR>" },
		{ "mA", ":Telescope lspmark<CR>" },
		{ "md", ":lua require('lspmark.bookmarks').delete_line()<CR>" },
		{ "mp", ":lua require('lspmark.bookmarks').paste_text()<CR>" },
		{ "mi", ":lua require('lspmark.bookmarks').modify_comment()<CR>" },
	},
	-- event = { "DirChanged" },
	lazy = false,
	config = function()
		require("lspmark").setup()
		require("lspmark.bookmarks").load_bookmarks() -- so that it also loads on startup
		vim.api.nvim_create_autocmd({ "DirChanged" }, {
			callback = function()
				require("lspmark.bookmarks").load_bookmarks()
			end,
			pattern = { "*" },
		})
	end,
}
