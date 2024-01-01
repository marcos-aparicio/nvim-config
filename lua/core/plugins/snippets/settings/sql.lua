local prequire = require("utils").prequire
local tablemerge = require("utils").tablemerge
local ls = prequire("luasnip")
if not ls then
	return
end

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local snippets = {
	s("all", { t("SELECT * FROM ") }),
	s("tables", { t("SELECT * FROM show_tables();") }),
	s("cols", { t("SELECT * FROM show_columns('"), i(1), t("');") }),
}
local sql_snipps = {
	s("all", { t("SELECT * FROM ") }),
	s("tables", { t("SELECT * FROM show_tables();") }),
	s("cols", { t("SELECT * FROM show_columns('"), i(1), t("');") }),
}
local mysql_snipps = {
	s("count", { t("SELECT COUNT(*) FROM ") }),
	s("all", { t("SELECT * FROM ") }),
	s("tables", { t("CALL show_tables(); ") }),
	s("cols", { t("DESCRIBE "), i(1), t(";") }),
}

ls.add_snippets("sql", sql_snipps)
ls.add_snippets("mysql", mysql_snipps)
