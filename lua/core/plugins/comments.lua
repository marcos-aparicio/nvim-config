return {
	"windwp/nvim-ts-autotag",
	"JoosepAlviste/nvim-ts-context-commentstring",
	{
		"numToStr/Comment.nvim",
		lazy = false,
		config = function()
			local commentFT = require("Comment.ft")

			require("Comment").setup({
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
				opleader = {
					---Line-comment keymap
					line = "gc",
					---Block-comment keymap
					block = "gs",
				},
				toggler = {
					line = "gcc",
					block = "gsc",
				},
				mappings = {
					basic = true,
					extra = true,
				},
			})
			commentFT.mysql = { "--%s" }
			commentFT.hurl = { "#%s" }
			commentFT.ledger = { "#%s" }
			commentFT.hledger = { "#%s" }
		end,
	},
}
