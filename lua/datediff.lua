NS = vim.api.nvim_create_namespace("datediff")
-- Function to get all parts of lines that match a pattern in the current buffer
function get_matching_parts(pattern)
	-- Get the current buffer
	local bufnr = vim.api.nvim_get_current_buf()
	-- Get the total number of lines in the buffer
	local total_lines = vim.api.nvim_buf_line_count(bufnr)
	-- Table to store matching parts
	local matching_parts = {}

	-- Iterate through each line in the buffer
	for i = 1, total_lines do
		-- Get the current line
		local line = vim.api.nvim_buf_get_lines(bufnr, i - 1, i, false)[1]
		-- Find all matches in the line
		for match in string.gmatch(line, pattern) do
			table.insert(matching_parts, { line_num = i, match_text = match })
		end
	end

	-- Return the table of matching parts
	return matching_parts
end

local pattern = "`=%s*date%(.-%) %- date%(%d%d%d%d%-%d%d%-%d%d%)`"
-- local pattern = "`=%s*date%(today%) %- date%(%d%d%d%d%-%d%d%-%d%d%)`"
local function get_dates(input_string)
	local pattern = "%((.-)%)" -- Pattern to match anything inside brackets
	-- Table to store matching content
	local matching_content = {}

	-- Use string.gmatch to find all matches of the pattern in the input string
	for match in string.gmatch(input_string, pattern) do
		table.insert(matching_content, match)
	end

	-- Return the table of matching content
	return matching_content
end

local autocmd = vim.api.nvim_create_autocmd

autocmd({ "BufRead", "BufWritePost" }, {
	pattern = "*.md",
	callback = function()
		-- Example usage: Find lines that match the pattern
		local bnr = vim.fn.bufnr("%")
		local matching_parts = get_matching_parts(pattern)

		-- Print the matching lines
		for i, match in ipairs(matching_parts) do
			local dates = get_dates(match.match_text)
			local cmd = vim.system({ "sh", "/home/marcos/.local/bin/ddiff", unpack(dates) }, { text = true })
			local output = cmd:wait()
			--
			if output.code == 1 then
				return
			end
			vim.api.nvim_buf_set_extmark(bnr, NS, match.line_num - 1, 0, {
				id = i,
				virt_text = { { vim.fn.trim(output.stdout), "IncSearch" } },
			})
		end
	end,
})
