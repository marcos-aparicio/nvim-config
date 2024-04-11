return {
	"tomasky/bookmarks.nvim",
	-- after = "telescope.nvim",
	--
	config = function()
		require("bookmarks").setup({
			sign_priority = 20, --set bookmark sign priority to cover other sign
			on_attach = function()
				local bm = require("bookmarks")
				local map = vim.keymap.set
				map("n", "mm", bm.bookmark_toggle) -- add or remove bookmark at current line
				map("n", "mi", bm.bookmark_ann) -- add or edit mark annotation at current line
				map("n", "mc", bm.bookmark_clean) -- clean all marks in local buffer
				map("n", "mn", bm.bookmark_next) -- jump to next mark in local buffer
				map("n", "mp", bm.bookmark_prev) -- jump to previous mark in local buffer
				map(
					"n",
					"ma",
					':Telescope bookmarks list layout_config={"width":0.95,"preview_width":0.5,"prompt_position":"top"} <CR>'
				)
			end,
		})
	end,
}
