-- Function to copy the current buffer's path to the clipboard
function copy_buffer_path()
	-- Get the current buffer's file path
	local buffer_path = vim.fn.expand("%:p")

	-- Use the git command to find the root of the git repository
	local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")

	-- Check if the buffer is inside a Git repository
	if vim.v.shell_error == 0 and git_root ~= "" then
		-- Convert buffer path to a relative path from the Git root
		local relative_path = string.sub(buffer_path, string.len(git_root) + 1)
		vim.fn.setreg("+", relative_path)
		vim.api.nvim_echo(
			{ { "Buffer path relative to Git root copied to clipboard: " .. relative_path, "Normal" } },
			true,
			{}
		)
	else
		-- If not in a Git repository, copy the full path
		vim.fn.setreg("+", buffer_path)
		vim.api.nvim_echo({ { "Buffer path copied to clipboard: " .. buffer_path, "Normal" } }, true, {})
	end
end

-- Command to call the Lua function
vim.cmd([[command! CopyBufferPath :lua copy_buffer_path()]])

-- Add a custom command to open Alacritty with the current buffer in read-only mode
vim.cmd([[
  command! -nargs=0 OpenAlacrittyReadonly :lua OpenAlacrittyReadonly()
]])

-- Function to open Alacritty with the current buffer in read-only mode
function OpenAlacrittyReadonly()
	local current_file = vim.fn.expand("%:p")
	local current_line = vim.fn.line(".")
	local current_col = vim.fn.col(".")

	local alacritty_command =
		string.format('alacritty --command nvim -c "set readonly" +%d,%d %s', current_line, current_col, current_file)
	vim.fn.jobstart(alacritty_command, {
		detach = true,
	})
end
