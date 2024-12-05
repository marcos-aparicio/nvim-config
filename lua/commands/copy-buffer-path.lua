local user_cmd = vim.api.nvim_create_user_command
local HOME = os.getenv("HOME")

-- Copies the current buffer's path to the clipboard with multiple options, it is a
-- callback from the nvim user command function. It accepts a range so that when
-- you call it from visual mode it will copy the range of lines.
--
-- @param args.full|git first arg is whether you want the full path or the git root path
copyBufferPath = function(args)
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
end

user_cmd("CopyBufferPath", copyBufferPath, {
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
