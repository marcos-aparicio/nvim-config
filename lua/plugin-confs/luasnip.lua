local ok, ls = pcall(require, "luasnip")
if not ok then
	return
end
local s = ls.snippet
local t = ls.text_node

ls.add_snippets("vimwiki", {
	s("todo", { t("- [ ] ") }),
})
ls.add_snippets("sql", {
	s("all", { t("SELECT * FROM ") }),
})
