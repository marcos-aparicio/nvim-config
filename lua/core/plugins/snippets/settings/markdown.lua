local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
	return
end

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

--- Retrieves the current date in a formatted string.
---
--- This function returns the current date in the format "YYYY-MM-DD" if `includeDay` is set to `true`,
--- or in the format "YYYY-MM" if `includeDay` is set to `false`.
---
--- @param includeDay? boolean  A boolean flag indicating whether to include the day in the date.
---
--- @return string stringDate The current date as a formatted string.
--- @see os.date
---
local function get_current_date(includeDay)
	local currentTime = os.date("*t") -- Get the current date and time as a table
	local currentMonth = currentTime.month -- Get the current month
	local currentYear = currentTime.year -- Get the current year
	local paddedMonth = string.format("%02d", currentMonth) -- Add padding to the month

	if not includeDay then
		return currentYear .. "-" .. paddedMonth
	end
	local paddedDay = string.format("%02d", currentTime.day)
	return currentYear .. "-" .. paddedMonth .. "-" .. paddedDay
end

local markdown_mappings = {
	s("todo", { t("- [ ] ") }),
	s("task", { t("* [ ] ") }),
	s("h6", { t("###### ") }),
	s("h5", { t("##### ") }),
	s("h4", { t("#### ") }),
	s("h3", { t("### ") }),
	s("h3", { t("### ") }),
	s("h2", { t("## ") }),
	s("h1", { t("# ") }),
	s("link", { t("["), i(1, "Titulo a mostrar"), t("]("), i(2, "Link pe"), t(")") }),
	s("bugreport", {
		t({ "### What is the issue description?", "" }),
		i(1),
		t({ "", "", "### What steps triggered the issue?", "" }),
		i(2),
		t({ "", "", "### What is the expected behaviour?", "" }),
		i(3),
		t({ "", "", "### What is the actual behaviour?", "" }),
		i(4),
	}),
	s("hoy", { t(get_current_date(true)) }),
}

-- ls.add_snippets("vimwiki", markdown_mappings)
ls.add_snippets("markdown", markdown_mappings)
