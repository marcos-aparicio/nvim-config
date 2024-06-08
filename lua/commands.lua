-- Function to copy the current buffer's path to the clipboard
function copy_buffer_path(args)
	if args == nil or #args["fargs"] < 1 then
		print("args is nil")
		return
	end

	local full_path = args["fargs"][1] == "full" or false
	local include_line = args["fargs"][2] == "include_line" or false
	local start_line, end_line

	if args.range then
		start_line = args.line1
		end_line = args.line2
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
			output_to_clipboard = output_to_clipboard .. " Line: " .. start_line
			if start_line ~= end_line then
				output_to_clipboard = output_to_clipboard .. " - " .. end_line
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
		output_to_clipboard = output_to_clipboard .. " Line: " .. start_line
		if start_line ~= end_line then
			output_to_clipboard = output_to_clipboard .. " - " .. end_line
		end
	end
	vim.fn.setreg("+", output_to_clipboard)
	vim.api.nvim_echo({ { "Buffer path copied to clipboard: " .. buffer_path, "Normal" } }, true, {})
end

vim.api.nvim_create_user_command("CopyBufferPath", copy_buffer_path, {
	desc = "Copy the current buffer's path with multiple options",
	nargs = "*",
	range = true,
	complete = function(_, cmdLine)
		local parts = vim.split(vim.trim(cmdLine), " ")
		if #parts == 1 then
			return { "full", "git" }
		end
		if #parts == 2 then
			return { "include_line" }
		end
	end,
})
vim.keymap.set({ "n" }, "<leader>cp", ":CopyBufferPath git<CR>")
vim.keymap.set({ "n" }, "<leader>cP", ":CopyBufferPath full<CR>")
vim.keymap.set({ "v" }, "<leader>cp", ":CopyBufferPath git include_line<CR>")
vim.keymap.set({ "v" }, "<leader>cP", ":CopyBufferPath full include_line<CR>")

vim.api.nvim_create_user_command("OpenAlacrittyReadonly", function()
	local current_file = vim.fn.expand("%:p")
	local current_line = vim.fn.line(".")
	local current_col = vim.fn.col(".")

	local alacritty_command =
		string.format("alacritty --command nvim -R +%d,%d %s", current_line, current_col, current_file)
	vim.fn.jobstart(alacritty_command, {
		detach = true,
	})
end, {
	desc = "Open alacritty with the current buffer in read-only mode",
})

local show_error = true
vim.api.nvim_create_user_command("ToggleShowingError", function()
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
vim.api.nvim_create_user_command("ToggleUseCondaPython", function()
	conda_python = not conda_python
	if conda_python then
		print("Using conda python")
		return
	end
	print("Using standard python")
end, {
	desc = "Using conda python or not when executing current buffer",
})

vim.api.nvim_create_user_command("PrintBufferPath", function()
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

vim.api.nvim_create_user_command("ExecuteCurrentBuffer", function()
	local filetype = vim.o.filetype
	local current_file = vim.fn.expand("%:p")
	local command = ""
	local curr_dir = vim.fn.getcwd()

	local redirect = show_error and "" or " 2>/dev/null"

	if filetype == "javascript" then
		command = "node"
	elseif filetype == "python" then
		if conda_python then
			command = "python "
		-- command = "when-changed " .. current_file .. " /home/marcos/anaconda3/envs/venv/bin/python " .. current_file
		else
			-- here you should also activate the virtual environment if needed
			local venv = vim.fn.systemlist("sh /home/marcos/.local/privbin/find_virtual_env " .. curr_dir)[1] or ""
			command = "source " .. venv .. " || echo 'not using a virtual env';python"
		end
	elseif filetype == "sh" then
		command = "sh"
	elseif filetype == "lua" then
		command = "lua"
	elseif filetype == "hurl" then
		command = "hurl --verbose"
	elseif filetype == "php" then
		command = "php "
	elseif string.match(current_file, "plt$") or filetype == "gp" or filetype == "plt" then
		command = "plot "
	end

	if command == "" then
		print("Not supported filetype")
		return
	end

	vim.cmd(":vs")
	vim.cmd(":term " .. command .. "" .. redirect .. " " .. current_file)
end, {
	desc = "Execute the current buffer",
})
