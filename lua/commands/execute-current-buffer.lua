local user_cmd = vim.api.nvim_create_user_command
local HOME = os.getenv("HOME")

local show_error = true
local function executeCurrentBuffer()
	local filetype = vim.o.filetype
	local current_file = vim.fn.expand("%:p")
	local curr_dir = vim.fn.expand("%:p:h")
	local redirect = show_error and "" or " 2>/dev/null"
	local usual_running = function(command)
		vim.cmd(":vs")
		vim.cmd(":term " .. command .. redirect .. " " .. current_file)
	end

	local filetype_command = {
		["java"] = "java",
		["python"] = "python",
		["sh"] = "sh",
		["lua"] = "lua",
		["hurl"] = "hurl --verbose",
		["plt"] = "plot",
	}

	local command = filetype_command[filetype] or ""
	if command ~= "" then
		usual_running(command)
		return
	end

	local filetype_function = {
		["javascript"] = function()
			if string.match(current_file, ".*test.js$") then
				vim.cmd(":vs")
				vim.cmd(":term npm run test %")
				return
			end
			usual_running("node")
		end,
		["php"] = function()
			vim.cmd(":vs")
			if string.match(current_file, ".*tests/Browser/.*%.php$") then
				vim.cmd(":term vendor/bin/sail dusk %")
				return
			end
			vim.cmd(":term vendor/bin/sail test %")
		end,
	}

	local exec = filetype_function[filetype] or function()
		print("Not supported filetype")
	end
	exec()
end

user_cmd("ExecuteCurrentBuffer", executeCurrentBuffer, { desc = "Execute the current buffer" })
