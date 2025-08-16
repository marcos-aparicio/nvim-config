return {
	"akinsho/toggleterm.nvim",
	version = "*",
	main = "toggleterm",
	opts = {
		autochdir = true,
		shade_terminals = false,
		highlights = {
			Normal = {
				guibg = "#0a0e14",
			},
		},
	},
	keys = {
		{ "<C-;>", "<Cmd>ToggleTerm<CR>", mode = { "t", "n" } },
		{ "<leader>lg", "<Cmd>TermExec direction=float cmd=lazygit<CR>", mode = { "t", "n" } },
		{ "<leader>ld", "<Cmd>TermExec direction=float cmd=lazydocker<CR>", mode = { "t", "n" } },
		-- Custom key for lf in a floating terminal
		{
			"<leader>lf",
			function()
				local Terminal = require("toggleterm.terminal").Terminal
				local sel = vim.fn.tempname()
				local cmd = ("bash -lc %q"):format("lf -selection-path " .. vim.fn.shellescape(sel))

				local term = Terminal:new({
					cmd = cmd,
					direction = "float",
					float_opts = {
						border = "rounded",
						width = math.floor(vim.o.columns * 0.85),
						height = math.floor(vim.o.lines * 0.85),
					},
					on_exit = function(_, _, exit_code, _)
						local paths = {}
						if vim.fn.filereadable(sel) == 1 then
							paths = vim.fn.readfile(sel) -- lf writes one path per line
						end
						pcall(vim.fn.delete, sel)

						-- proceed if you actually have selection, regardless of exit_code
						if #paths == 0 then
							vim.notify("No files selected", vim.log.levels.WARN)
							return
						end

						-- your follow-up action here (yank, send to CopilotChat, etc.)
						vim.fn.setreg("+", table.concat(paths, "\n"))
						vim.notify("Selected:\n" .. table.concat(paths, "\n"))
					end,
					close_on_exit = true,
				})

				term:open()
			end,
			mode = { "n" },
			desc = "Pick file(s) via lf in floating terminal",
		},
	},
}
