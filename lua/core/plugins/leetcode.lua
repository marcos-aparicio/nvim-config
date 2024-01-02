local leet_arg = "leetcode.nvim"

return {
	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",

			-- optional
			"nvim-treesitter/nvim-treesitter",
			-- "rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = leet_arg ~= vim.fn.argv()[1],
		opts = {
			-- configuration goes here
			arg = leet_arg,
			lang = "javascript",
			hooks = {
				LeetEnter = {
					function()
						local M = require("mappings")
						M.nmap("<leader>ls", "<cmd>Leet submit<cr>")
						M.nmap("<leader>lt", "<cmd>Leet test<cr>")
						M.nmap("<leader>ld", "<cmd>Leet desc<cr>")
					end,
				},
			},
		},
	},
}
