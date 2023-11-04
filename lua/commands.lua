-- Function to copy the current buffer's path to the clipboard
function copy_buffer_path(full_path)
	-- Get the current buffer's file path
	local buffer_path = vim.fn.expand("%:p")

	if full_path then
		vim.fn.setreg("+", buffer_path)
		vim.api.nvim_echo({ { "Buffer path copied to clipboard: " .. buffer_path, "Normal" } }, true, {})
		return
	end

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
vim.cmd([[
command! CopyGitPath :lua copy_buffer_path()
command! CopyFullPath :lua copy_buffer_path(true)
command! StringProcessing :lua string_processing_buffer_testing()
command! ExecuteCurrentBuffer :lua ExecuteCurrentBuffer()
" Add a custom command to open Alacritty with the current buffer in read-only mode
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

function string_processing_buffer_testing()
	local tempname = vim.fn.tempname()
	local stringProcessingTemplate = "/home/marcos/.local/privbin/string-processing"
	vim.cmd("edit " .. tempname)
	vim.cmd("read !cat " .. vim.fn.shellescape(stringProcessingTemplate))
	vim.cmd("1delete") -- Delete all lines in the buffer
	vim.cmd("w")
end

function ExecuteCurrentBuffer()
	-- local tempname = vim.fn.tempname()
	local filetype = vim.o.filetype
	local current_file = vim.fn.expand("%:p")
	local command = ""

	if filetype == "javascript" then
		command = "node"
	elseif filetype == "python" then
		-- here you should also activate the virtual environment if needed
		command = "python"
	elseif filetype == "sh" then
		command = "sh"
	end

	if command == "" then
		print("Not supported filetype")
		return
	end

	vim.cmd(":vs")
	vim.cmd(":term " .. command .. " " .. current_file)
end
