local ok, ls = pcall(require, "luasnip")
if not ok then
	return
end
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("vimwiki", {
	s("todo", { t("- [ ] ") }),
	s("task", { t("* [ ] ") }),
})
ls.add_snippets("sql", {
	s("all", { t("SELECT * FROM ") }),
	s("tables", { t("SELECT * FROM show_tables();") }),
	s("cols", { t("SELECT * FROM show_columns('"), i(1), t("');") }),
})
