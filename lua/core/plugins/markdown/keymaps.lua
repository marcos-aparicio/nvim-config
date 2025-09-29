local M = {}

-- Credit to linkarzu's dotfiles for bullet point functions
local function toggle_bullet_point()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_buffer = vim.api.nvim_get_current_buf()
	local start_row = cursor_pos[1] - 1
	local col = cursor_pos[2]
	local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]

	if line:match("^%s*%-") then
		line = vim.trim(line:gsub("^%s*%-", ""))
		vim.api.nvim_buf_set_lines(current_buffer, start_row, start_row + 1, false, { line })
		return
	end

	local left_text = line:sub(1, col)
	local bullet_start = left_text:reverse():find("\n")
	if bullet_start then
		bullet_start = col - bullet_start
	end

	local right_text = line:sub(col + 1)
	local bullet_end = right_text:find("\n")
	local end_row = start_row
	while not bullet_end and end_row < vim.api.nvim_buf_line_count(current_buffer) - 1 do
		end_row = end_row + 1
		local next_line = vim.api.nvim_buf_get_lines(current_buffer, end_row, end_row + 1, false)[1]
		if next_line == "" then
			break
		end
		right_text = right_text .. "\n" .. next_line
		bullet_end = right_text:find("\n")
	end
	if bullet_end then
		bullet_end = col + bullet_end
	end

	local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, end_row + 1, false)
	local text = table.concat(text_lines, "\n")
	local new_text = "- " .. text
	local new_lines = vim.split(new_text, "\n")
	vim.api.nvim_buf_set_lines(current_buffer, start_row, end_row + 1, false, new_lines)
end

local function toggle_todo_checkbox()
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	local current_buffer = vim.api.nvim_get_current_buf()
	local start_row = cursor_pos[1] - 1
	local col = cursor_pos[2]
	local line = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)[1]

	if line:match("^%s*%- %s[.]") then
		line = vim.trim(line:gsub("^%s*%-%s[.]", ""))
		vim.api.nvim_buf_set_lines(current_buffer, start_row, start_row + 1, false, { line })
		return
	end

	-- Similar logic as toggle_bullet_point but for todo items
	local text_lines = vim.api.nvim_buf_get_lines(current_buffer, start_row, start_row + 1, false)
	local text = table.concat(text_lines, "\n")
	local new_text = "- [ ] " .. text
	local new_lines = vim.split(new_text, "\n")
	vim.api.nvim_buf_set_lines(current_buffer, start_row, start_row + 1, false, new_lines)
end

local function jump_to_header(header_text, keymap, desc)
	vim.keymap.set("n", keymap, function()
		local current_pos = vim.fn.getpos(".")
		vim.cmd("normal! gg")
		local found = vim.fn.search("^## " .. header_text, "W")
		if found > 0 then
			vim.cmd("normal! j")
		else
			vim.fn.setpos(".", current_pos)
			vim.notify('Header "## ' .. header_text .. '" not found', vim.log.levels.WARN)
		end
	end, { desc = desc })
end

local function open_markdown_link()
	local url = vim.fn.expand("<cfile>")
	if url and url:match("^https?://") then
		local open_cmd = vim.g.is_wsl == 1 and { "powershell.exe", "Start-Process" } or { "xdg-open" }
		vim.fn.jobstart(vim.list_extend(open_cmd, { url }), { detach = true })
	else
		vim.notify("No valid URL under cursor", vim.log.levels.WARN)
	end
end

function M.setup_buffer_keymaps()
	local telescope = require("core.plugins.markdown.telescope")
	local task_mgmt = require("core.plugins.markdown.task-management")

	-- Project tag Telescope finders
	vim.keymap.set("n", "<leader>mp", function()
		telescope.get_tag_telescope_finder("project", true)
	end, { buffer = true, desc = "Search for 'project' tag" })

	vim.keymap.set("n", "<leader>mc", function()
		telescope.get_tag_telescope_finder("current-project", true)
	end, { buffer = true, desc = "Search for 'current-project' tag" })

	vim.keymap.set("n", "<leader>mf", function()
		telescope.get_tag_telescope_finder("finished-project", true)
	end, { buffer = true, desc = "Search for 'finished-project' tag" })

	-- Tag search keymaps
	vim.keymap.set("n", "<leader>kt", telescope.pick_tag_and_search, { buffer = true, desc = "Pick tag and search" })

	vim.keymap.set(
		"n",
		"<leader>ta",
		telescope.pick_task_tag_and_search,
		{ buffer = true, desc = "Pick task tag and search" }
	)
	vim.keymap.set("n", "<leader>tn", function()
    telescope.search_tasks_with_tag("_next")
  end, { buffer = true, desc = "Search tasks with tag _next" })

	-- Text formatting keymaps
	vim.keymap.set("n", "<leader>md", toggle_bullet_point, { buffer = true, desc = "Toggle bullet point (dash)" })
	vim.keymap.set("n", "<leader>ml", toggle_todo_checkbox, { buffer = true, desc = "Toggle todo (dash)" })

	-- Navigation keymaps
	jump_to_header("To Do", "<leader>mt", "Jump to To Do section")
	jump_to_header("Notes", "<leader>mn", "Jump to Notes section")

	-- Link handling
	vim.keymap.set("n", "<leader>mo", open_markdown_link, { buffer = true, desc = "Open markdown link in browser" })

	-- Task management
	vim.keymap.set(
		"n",
		"<localleader>d",
		task_mgmt.toggle_task_state,
		{ buffer = true, desc = "Toggle task state (blank → progress → done → blank)" }
	)

	-- Task search keymaps
	vim.keymap.set(
		"n",
		"<leader>tc",
		telescope.search_completed_tasks,
		{ buffer = true, desc = "Search for completed tasks" }
	)
	vim.keymap.set(
		"n",
		"<leader>ti",
		telescope.search_progress_tasks,
		{ buffer = true, desc = "Search for tasks in progress" }
	)
	vim.keymap.set(
		"n",
		"<leader>tt",
		telescope.search_incomplete_tasks,
		{ buffer = true, desc = "Search for incomplete tasks" }
	)
end

return M
