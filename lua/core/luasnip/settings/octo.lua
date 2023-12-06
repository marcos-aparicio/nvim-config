local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
	return
end
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

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
