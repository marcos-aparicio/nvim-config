return {
	{
		"nvim-neotest/neotest",
		ft = { "python", "py", "typescript", "ts", "javascript", "js" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
			"marilari88/neotest-vitest",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						args = { "--log-level", "DEBUG" },
						runner = "pytest",
					}),
					require("neotest-vitest"),
				},
			})
			vim.keymap.set("n", "<leader>tr", function()
				require("neotest").run.run()
			end)
			vim.keymap.set("n", "<leader>tt", function()
				require("neotest").run.run(vim.fn.expand("%"))
			end)
			vim.keymap.set("n", "<leader>ts", function()
				require("neotest").summary.toggle()
			end)
			vim.keymap.set("n", "<leader>to", function()
				require("neotest").output.open({ enter = true, auto_close = true })
			end)
			vim.keymap.set("n", "<leader>tO", function()
				require("neotest").output_panel.toggle()
			end)
			vim.keymap.set("n", "<leader>tw", function()
				require("neotest").watch.toggle(vim.fn.expand("%"))
			end)
		end,
	},
}
