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

ls.add_snippets("javascript", {
	s("state", { t("const ["), i(1), t(", set"), f(setState, { 1 }), t("] = useState("), i(2), t(");") }),
})

-- Material UI tags
ls.add_snippets("javascript", {
	s("box", { t("<Box>"), i(1), t("</Box>") }),
	s("grid", { t("<Grid>"), i(1), t("</Grid>") }),
	s("typo", { t("<Typography>"), i(1), t("</Typography>") }),
})
