-- Function to copy the current buffer's path to the clipboard
function copy_buffer_path()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.api.nvim_echo({ { "Buffer path copied to clipboard: " .. path, "Normal" } }, true, {})
end

-- Command to call the Lua function
vim.cmd([[command! CopyBufferPath :lua copy_buffer_path()]])
