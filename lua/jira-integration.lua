local M = require("mappings")

local ok, telescope = pcall(require, "telescope")
if not ok then
	return
end

--[[
  Based on a "ticket" string representation from jira-cli tool returns a string with a recommended branch name
  for that ticket based on criteria from my job
  Returns:
    (string): branch name based on ticket and job conventions
--]]
local function createBranchNameByTicket(ticket)
	-- local separator = "%s+"
	local separator = "\t"
	local ticket_parts = {}
	for ticket_part in ticket:gmatch("[^" .. separator .. "]+") do
		table.insert(ticket_parts, ticket_part)
	end

	local ticket_type = string.lower(ticket_parts[1])
	local ticket_id = ticket_parts[2]
	local ticket_title = ticket_parts[3]
	local ticket_status = ticket_parts[4]

	if ticket_type == "story" then
		ticket_type = "feature"
	end
	local proccesed_title = string.gsub(ticket_title, " / ", "/")
	proccesed_title = string.gsub(proccesed_title, " ", "-")
	proccesed_title = string.gsub(proccesed_title, "-+", "-")
	proccesed_title = string.gsub(proccesed_title, ":", "")

	local branch_convention = ticket_type .. "/" .. ticket_id .. "-" .. proccesed_title

	return branch_convention
end
local function extractDataFromTicketString(ticket)
	local separator = "\t"
	local ticket_parts = {}
	for ticket_part in ticket:gmatch("[^" .. separator .. "]+") do
		table.insert(ticket_parts, ticket_part)
	end

	local ticket_type = ticket_parts[1]
	local ticket_id = ticket_parts[2]
	local ticket_title = ticket_parts[3]

	local ticket_status_values = {
		["In Progress"] = "🔧",
		["Review"] = "🔍",
		["Done"] = "✅",
		["To Do"] = "📝",
	}
	local ticket_status = ticket_status_values[ticket_parts[4]] or ticket_parts[4]

	local ticket_assignee = ticket_parts[5]
	local output = {
		ticket = ticket,
		ticket_type = ticket_type,
		ticket_id = ticket_id,
		ticket_title = ticket_title,
		ticket_status = ticket_status,
		ticket_assignee = ticket_assignee,
	}
	return output
end

local function tableFormatting(width, original_str)
	local output = original_str or ""
	if #original_str > width then
		output = string.sub(original_str, 1, width - 3)
		output = output .. "..."
		return output
	else
		output = output .. string.rep(" ", width - #original_str)
	end

	return output
end

-- Create the Telescope picker
function JiraPicker(option, argString)
	local actions = require("telescope.actions")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local sorters = require("telescope.sorters")
	local state = require("telescope.actions.state")
	local entry_display = require("telescope.pickers.entry_display")
	local tickets = {}

	local initial_filter = "sprint list --current"
	if option == "backlog" then
		initial_filter = "issue list -q \"Sprint is EMPTY AND status != 'Done'\""
	end
	if string.match(argString, "^me") then
		argString = string.gsub(argString, "^me", ' -a "$(jira me)" ')
	end

	local output = vim.fn.systemlist(
		"source $HOME/.config/zsh/zshrc;$HOME/go/bin/jira "
			.. initial_filter
			.. " --plain --no-headers --columns TYPE,KEY,SUMMARY,STATUS,ASSIGNEE "
			.. argString
	)

	for _, ticket in ipairs(output) do
		local proccesed_ticket = extractDataFromTicketString(ticket)
		table.insert(tickets, proccesed_ticket)
	end

	local displayer = entry_display.create({
		separator = "   ",
		items = {
			{ string_width = 100 },
			{ string_width = 100 },
			{ string_width = 100 },
			{ string_width = 100 },
			{ string_width = 100 },
			{ string_width = 100 },
		},
	})

	-- Create a Telescope picker
	local picker = pickers.new({}, {
		prompt_title = option == "sprint" and "Jira tickets for this sprint" or "Backlog",
		layout_config = {
			width = 0.95,
		},
		finder = finders.new_table({
			results = tickets,
			entry_maker = function(entry)
				if entry.ticket_assignee == nil then
					entry.ticket_assignee = "-"
				end
				return {
					value = entry.ticket,
					ordinal = entry.ticket_id,
					display = displayer({
						{ tableFormatting(10, entry.ticket_id), "ID" },
						{ tableFormatting(10, entry.ticket_status), "Status" },
						{ tableFormatting(15, entry.ticket_assignee), "ASSIGNEE" },
						{ tableFormatting(100, entry.ticket_title), "Title" },
					}),
				}
			end,
		}),
		sorter = sorters.get_generic_fuzzy_sorter(),
		attach_mappings = function(prompt_bufnr, map)
			local select_item = function()
				local selection = state.get_selected_entry()

				actions.close(prompt_bufnr)
				local branch_name = createBranchNameByTicket(selection.value)
				if selection then
					vim.cmd("echo '" .. branch_name .. " was generated and copied to the clipboard'")
					vim.fn.setreg("+", branch_name)
					-- vim.cmd("echo " .. selection.value)
				end
			end

			-- Map <CR> to select_item function
			map("i", "<CR>", select_item)
			map("n", "<CR>", select_item)

			return true
		end,
	})

	-- Open the Telescope picker
	picker:find()
end

function JiraCommand(arg_string)
	local action = arg_string:match("%S+")
	local additional_args = arg_string:gsub("^%s*%S+%s*", "")

	if action ~= "backlog" and action ~= "sprint" then
		print("Not supported options. Only supported are 'backlog' and 'sprint'")
		return
	end

	JiraPicker(action, additional_args)
end

--

-- vim.cmd([[command! JiraWeeklyIssues :lua JiraPicker()]])
vim.cmd([[
command! -nargs=* -complete=customlist,Completions Jira lua JiraCommand(<q-args>)
fun Completions(ArgLead,CmdLine,CursorPos)
  let completions = ["backlog", "sprint"] " List of completions
  let filtered = [] " Filtered completions based on ArgLead
  for comp in completions
    if matchstr(comp, "^" . a:ArgLead) == a:ArgLead
      call add(filtered, comp)
    endif
  endfor
  return filtered
endfun
]])
M.nmap("<leader>js", ":Jira sprint ")
M.nmap("<leader>jb", ":Jira backlog ")
