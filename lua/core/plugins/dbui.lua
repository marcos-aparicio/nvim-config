vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_force_echo_notifications = 1
vim.g.db_ui_save_location = os.getenv("HOME") .. "/.local/share/db_ui/connections.json"

return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		"tpope/vim-dotenv",
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	keys = {
		{ "<leader><leader>db", ":tab DBUI<CR>" },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	opts = function()
		vim.keymap.set("n", "<C-b>", ":DBUIToggle<CR>")
		vim.keymap.set("n", "<C-n>", ":DBUIToggle<CR>")
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "dbout",
			callback = function()
				local buff = tonumber(vim.fn.expand("<abuf>"), 10)
				vim.keymap.set("n", "<leader>q", ":Bdelete<CR>")
				vim.keymap.set("n", "<tab>", function()
					-- Get the buffer numbers of all open buffers
					local buffer_list = vim.api.nvim_list_bufs()

					-- Iterate through the buffer list
					for _, buffer_number in ipairs(buffer_list) do
						-- Check if the buffer has a filetype of SQL
						if vim.api.nvim_buf_get_option(buffer_number, "filetype") == "sql" then
							-- Iterate through all windows
							for _, winid in ipairs(vim.api.nvim_list_wins()) do
								-- Get the buffer ID of the window
								local buf_id = vim.api.nvim_win_get_buf(winid)
								-- If the buffer ID matches the target buffer, move the cursor to the window
								if buf_id == buffer_number then
									vim.api.nvim_set_current_win(winid)
									break
								end
							end
							break
						end
					end
				end, { noremap = true, buffer = buff })
			end,
		})
		return {}
	end,
}
