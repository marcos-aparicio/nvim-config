-- Function to copy the current buffer's path to the clipboard
function copy_buffer_path()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.api.nvim_echo({ { "Buffer path copied to clipboard: " .. path, "Normal" } }, true, {})
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
