local user_cmd = vim.api.nvim_create_user_command
local HOME = os.getenv("HOME")

local M = {
	-- Copies the current buffer's path to the clipboard with multiple options, it is a
	-- callback from the nvim user command function. It accepts a range so that when
	-- you call it from visual mode it will copy the range of lines.
	--
	-- @param args.full|git first arg is whether you want the full path or the git root path
	copy_buffer_path = function(args)
		if args == nil or #args["fargs"] < 1 then
			print("args is nil")
			return
		end

		local full_path = args["fargs"][1] == "full" or false
		local include_line = args["fargs"][2] == "include_line" or false

		local buffer_path = vim.fn.expand("%:p")
		-- Use the git command to find the root of the git repository
		local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")
		local output_to_clipboard = buffer_path

		-- First check if the user wants git path or check if the buffer is inside a Git repository
		if not full_path and vim.v.shell_error == 0 and git_root ~= "" then
			-- Convert buffer path to a relative path from the Git root
			local relative_path = string.sub(buffer_path, string.len(git_root) + 1)
			output_to_clipboard = relative_path
		end

		if include_line and args.range then
			output_to_clipboard = output_to_clipboard .. " Line: " .. args.line1
			if args.line1 ~= args.line2 then
				output_to_clipboard = output_to_clipboard .. " - " .. args.line2
			end
		end

		vim.fn.setreg("+", output_to_clipboard)
		local message = full_path and "Buffer path copied to clipboard: "
			or "Buffer path relative to Git root copied to clipboard: "
		vim.api.nvim_echo({ { message .. buffer_path, "Normal" } }, true, {})
	end,
}

user_cmd("CopyBufferPath", M.copy_buffer_path, {
	desc = "Copy the current buffer's path with multiple options",
	nargs = "*",
	range = true,
	complete = function(_, cmdLine)
		local parts = vim.split(vim.trim(cmdLine), " ")
		if #parts == 1 then
			return { "full", "git" }
		end
	end,
})
vim.keymap.set({ "n" }, "<leader>cp", ":CopyBufferPath git<CR>")
vim.keymap.set({ "n" }, "<leader>cP", ":CopyBufferPath full<CR>")
vim.keymap.set({ "v" }, "<leader>cp", ":CopyBufferPath git include_line<CR>")
vim.keymap.set({ "v" }, "<leader>cP", ":CopyBufferPath full include_line<CR>")

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

user_cmd("ExecuteCurrentBuffer", function()
	local filetype = vim.o.filetype
	local current_file = vim.fn.expand("%:p")
	local command = ""
	local curr_dir = vim.fn.expand("%:p:h")

	local redirect = show_error and "" or " 2>/dev/null"

	if filetype == "javascript" then
		command = "node"
	elseif filetype == "python" then
		local cmd = vim.system({ "sh", HOME .. "/.local/privbin/find_virtual_env", curr_dir }, { text = false })
		local venv = cmd:wait()

		if conda_python or venv.code == 1 then
			command = "python "
		else
			command = "source " .. vim.fn.trim(venv.stdout) .. " && python"
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
	vim.cmd(":term " .. command .. redirect .. " " .. current_file)
end, {
	desc = "Execute the current buffer",
})
