-- Function to copy the current buffer's path to the clipboard
function copy_buffer_path(full_path, include_line)
	local start_line
	local end_line

	if vim.fn.visualmode() == "V" then
		start_line, _ = unpack(vim.api.nvim_buf_get_mark(0, "<"))
		end_line, _ = unpack(vim.api.nvim_buf_get_mark(0, ">"))
	else
		local cursor = vim.api.nvim_win_get_cursor(0)
		start_line = cursor[1]
		end_line = start_line
	end

	-- Get the current buffer's file path
	local buffer_path = vim.fn.expand("%:p")

	if full_path then
		local output_to_clipboard = buffer_path
		if include_line then
			if start_line == end_line then
				output_to_clipboard = output_to_clipboard .. " Line: " .. start_line
			else
				output_to_clipboard = output_to_clipboard .. " Lines: " .. start_line .. " - " .. end_line
			end
		end
		vim.fn.setreg("+", output_to_clipboard)
		vim.api.nvim_echo({ { "Buffer path copied to clipboard: " .. buffer_path, "Normal" } }, true, {})
		return
	end

	-- Use the git command to find the root of the git repository
	local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")

	-- Check if the buffer is inside a Git repository
	if vim.v.shell_error == 0 and git_root ~= "" then
		-- Convert buffer path to a relative path from the Git root
		local relative_path = string.sub(buffer_path, string.len(git_root) + 1)
		local output_to_clipboard = relative_path

		if include_line then
			if start_line == end_line then
				output_to_clipboard = output_to_clipboard .. " Line: " .. start_line
			else
				output_to_clipboard = output_to_clipboard .. " Lines: " .. start_line .. " - " .. end_line
			end
		end
		vim.fn.setreg("+", output_to_clipboard)
		vim.api.nvim_echo(
			{ { "Buffer path relative to Git root copied to clipboard: " .. relative_path, "Normal" } },
			true,
			{}
		)
		return
	end
	-- If not in a Git repository, copy the full path
	local output_to_clipboard = buffer_path
	if include_line then
		if start_line == end_line then
			output_to_clipboard = output_to_clipboard .. " Line: " .. start_line
		else
			output_to_clipboard = output_to_clipboard .. " Lines: " .. start_line .. " - " .. end_line
		end
	end
	vim.fn.setreg("+", output_to_clipboard)
	vim.api.nvim_echo({ { "Buffer path copied to clipboard: " .. buffer_path, "Normal" } }, true, {})
end

function show_buffer_path()
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
end

-- Command to call the Lua function
vim.cmd([[
command! CopyGitPath :lua copy_buffer_path()
command! CopyFullPath :lua copy_buffer_path(true)
command! StringProcessing :lua string_processing_buffer_testing()
command! ExecuteCurrentBuffer :lua ExecuteCurrentBuffer()
command! PrintBufferPath :lua show_buffer_path()
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
	local curr_dir = vim.fn.getcwd()

	if filetype == "javascript" then
		command = "node"
	elseif filetype == "python" then
		-- here you should also activate the virtual environment if needed
		local venv = vim.fn.systemlist("sh /home/marcos/.local/privbin/find_virtual_env " .. curr_dir)[1] or ""
		command = "source " .. venv .. " && python"
	elseif filetype == "sh" then
		command = "sh"
	elseif filetype == "lua" then
		command = "lua"
	elseif filetype == "hurl" then
		command = "hurl --verbose"
	elseif filetype == "php" then
		command = "php "
	elseif string.match(current_file, "plt$") or filetype == "gp" or filetype == "plt" then
		command = "gnuplot "
	end

	if command == "" then
		print("Not supported filetype")
		return
	end

	vim.cmd(":vs")
	vim.cmd(":term " .. command .. " " .. current_file)
end
