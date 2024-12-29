return {
	{ "windwp/nvim-ts-autotag", event = { "BufReadPre", "BufNewFile" } },
	{ "JoosepAlviste/nvim-ts-context-commentstring", event = { "BufReadPre", "BufNewFile" } },
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		main = "Comment",
		opts = function()
			local ft = require("Comment.ft")
			ft.blade = "{{-- %s --}}"
			ft.mysql = "--%s"
			ft.hurl = "#%s"
			ft.taskedit = "#%s"
			ft.ledger = "#%s"
			ft.hledger = "#%s"
			return {
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
			}
		end,
	},
}
