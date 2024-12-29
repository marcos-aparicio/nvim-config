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
		opts = function()
			local neotest = require("neotest")
			local map = vim.keymap.set
			map("n", "<leader>tr", function()
				neotest.run.run()
			end)
			map("n", "<leader>tt", function()
				neotest.run.run(vim.fn.expand("%"))
			end)
			map("n", "<leader>ts", function()
				neotest.summary.toggle()
			end)
			map("n", "<leader>to", function()
				neotest.output.open({ enter = true, auto_close = true })
			end)
			map("n", "<leader>tO", function()
				neotest.output_panel.toggle()
			end)
			map("n", "<leader>tw", function()
				neotest.watch.toggle(vim.fn.expand("%"))
			end)

			return {
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						args = { "--log-level", "DEBUG" },
						runner = "pytest",
					}),
					require("neotest-vitest"),
				},
			}
		end,
	},
}
