return {
	"windwp/nvim-ts-autotag",
	"JoosepAlviste/nvim-ts-context-commentstring",
	{
		"numToStr/Comment.nvim",
		lazy = false,
		main = "Comment",
		opts = {
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
		},
		config = function(_, opts)
			opts["pre_hook"] = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
			require("Comment").setup(opts)
			local ft = require("Comment.ft")
			ft.blade = "{{-- %s --}}"
			ft.mysql = "--%s"
			ft.hurl = "#%s"
			ft.taskedit = "#%s"
			ft.ledger = "#%s"
			ft.hledger = "#%s"
		end,
	},
}
