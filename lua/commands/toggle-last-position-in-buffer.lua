local last_cursor_by_buf = {}

local function toggleToLastPositionInBuffer()
	local buf = vim.api.nvim_get_current_buf()
	local curr_pos = vim.api.nvim_win_get_cursor(0)
	if last_cursor_by_buf[buf] then
		vim.api.nvim_win_set_cursor(0, last_cursor_by_buf[buf])
	end
	last_cursor_by_buf[buf] = curr_pos
	vim.cmd("normal! zz")
end

vim.api.nvim_create_user_command("ToggleToLastPositionInBuffer", toggleToLastPositionInBuffer, {
	desc = "Goes to the last position in the current buffer, if done again then return to where you were before instead of your usual <C-o> behaviour",
})

vim.keymap.set({ "n" }, "<leader>j", ":ToggleToLastPositionInBuffer<CR>")
