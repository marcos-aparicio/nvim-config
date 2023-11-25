local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
	return
end
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("python", {
	s("ptype", { t("print(type("), i(1, "variable"), t("))") }),
	s("plist", { t("print(', '.join(str(item) for item in "), i(1, "my_list"), t("))") }),
})
