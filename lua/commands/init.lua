require("commands.copy-buffer-path")
require("commands.execute-current-buffer")
require("commands.toggle-last-position-in-buffer")

local user_cmd = vim.api.nvim_create_user_command

user_cmd("OpenAlacrittyReadonly", function()
	local current_file = vim.fn.expand("%:p")
	local current_line, current_col = unpack(vim.api.nvim_win_get_cursor(0))

	local alacritty_command =
		string.format("alacritty --command nvim %s -R '+call cursor(%d, %d)'", current_file, current_line, current_col)
	vim.fn.jobstart(alacritty_command, {
		detach = true,
	})
end, {
	desc = "Open alacritty with the current buffer in read-only mode",
})

local show_error = true
user_cmd("ToggleShowingError", function()
	show_error = not show_error
	if show_error then
		print("not showing 2>")
		return
	end
	print("showing 2>")
end, {
	desc = "Toggle showing 2> when executing current buffer",
})

local conda_python = false
user_cmd("ToggleUseCondaPython", function()
	conda_python = not conda_python
	if conda_python then
		print("Using conda python")
		return
	end
	print("Using standard python")
end, {
	desc = "Using conda python or not when executing current buffer",
})

user_cmd("PrintBufferPath", function()
	local buffer_path = vim.fn.expand("%:p")
	print("Buffer's absolute path: " .. buffer_path)
	-- Use the git command to find the root of the git repository
	local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")

	-- Check if the buffer is inside a Git repository
	if vim.v.shell_error == 0 and git_root ~= "" then
		-- Convert buffer path to a relative path from the Git root
		local relative_path = string.sub(buffer_path, string.len(git_root) + 1)
		print("Buffer's git root path: " .. relative_path)
	end
end, {
	desc = "Show the current buffer's path",
})
vim.keymap.set({ "n" }, "<leader>cc", ":PrintBufferPath<CR>")
