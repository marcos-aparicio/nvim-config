local ok, ls = pcall(require, "luasnip")
if not ok then
	return
end
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

ls.add_snippets("vimwiki", {
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
})
ls.add_snippets("sql", {
	s("all", { t("SELECT * FROM ") }),
	s("tables", { t("SELECT * FROM show_tables();") }),
	s("cols", { t("SELECT * FROM show_columns('"), i(1), t("');") }),
})

local function setState(args, parent, user_args)
	local state = args[1][1]
	return string.upper(string.sub(state, 1, 1)) .. string.sub(state, 2)
end

local function repeatStr(args, _, _)
	return args[1]
end

ls.add_snippets("javascript", {
	s("state", { t("const ["), i(1), t(", set"), f(setState, { 1 }), t("] = useState("), i(2), t(");") }),
	s("log", { t("console.log("), i(1), t(");") }),
	s("logs", { t("console.log(`"), i(1), t("`);") }),
	s("logv", { t('console.log("'), i(1), t(' ",'), i(2), t(");") }),
	s("$$", { t("${"), i(1), t("}") }),
	-- repeated prop and value
	s("rpr", { i(1), t("={"), f(repeatStr, { 1 }), t("}") }),
	s("reactdoc", {
		t({ "/**", " * " }),
		i(1, "Title"),
		t({ "", " * " }),
		i(2, "Description"),
		t({ "", " *", " * @param {Object} props - Component props", " *", " * @returns {React.Component} " }),
		i(3, "Returns"),
		t({ "", " */" }),
	}),
	s("dpar", {
		t("@param {"),
		i(1, "Type"),
		t("} "),
		i(2, "Parameter name"),
		t(" - "),
		i(3, "Parameter description"),
	}),
})

-- Material UI tags
ls.add_snippets("javascript", {
	s("box", { t("<Box>"), i(1), t("</Box>") }),
	s("grid", { t("<Grid>"), i(1), t("</Grid>") }),
	s("typo", { t("<Typography>"), i(1), t("</Typography>") }),
})

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
	return currentYear .. "-" .. paddedMonth .. "-" .. currentTime.day
end

-- Hledger tags
ls.add_snippets("ledger", {
	s("simple", {

		t({ get_current_date(false) .. "-" }),
		i(1, "insert date"),
		t({ " " }),
		i(2, "description"),
		t({ "", "  " }),
		i(3, "first_account"),
		t({ "  " }),
		i(4, "ammount"),
		t({ "", "  " }),
		i(5, "second_account"),
	}),
	s("tod", {
		t({ get_current_date(true) }),
		t({ " " }),
		i(1, "description"),
		t({ "", "  " }),
		i(2, "first_account"),
		t({ "  " }),
		i(3, "ammount"),
		t({ "", "  " }),
		i(4, "second_account"),
	}),
})

ls.add_snippets("octo", {
	s("todo", { t("- [ ] ") }),
	s("h6", { t("###### ") }),
	s("h5", { t("##### ") }),
	s("h4", { t("#### ") }),
	s("h3", { t("### ") }),
	s("h3", { t("### ") }),
	s("h2", { t("## ") }),
	s("h1", { t("# ") }),
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
	s("prdesc", {
		t({ "### What was done in this branch?", "" }),
		i(1),
		t({ "", "", "### Possible ways to test this branch", "" }),
		i(2),
	}),
})

ls.add_snippets("python", {
	s("ptype", { t("print(type("), i(1, "variable"), t("))") }),
	s("plist", { t("print(', '.join(str(item) for item in "), i(1, "my_list"), t("))") }),
})
