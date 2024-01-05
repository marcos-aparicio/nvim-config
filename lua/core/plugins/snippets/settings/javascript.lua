local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
	return
end
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function setState(args, parent, user_args)
	local state = args[1][1]
	return string.upper(string.sub(state, 1, 1)) .. string.sub(state, 2)
end

local function repeatStr(args, _, _)
	return args[1]
end

local snippets = {
	s("state", { t("const ["), i(1), t(", set"), f(setState, { 1 }), t("] = useState("), i(2), t(");") }),
	s("log", { t("console.log("), i(1), t(");") }),
	s("logs", { t("console.log(`"), i(1), t("`);") }),
	s("logv", { t('console.log("'), i(1), t(' ",'), i(2), t(");") }),
	s("lv", { t('console.log("'), i(1), t(': ",'), f(repeatStr, { 1 }), t(");") }),
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
	-- Material UI tags
	s("box", { t("<Box>"), i(1), t("</Box>") }),
	s("grid", { t("<Grid>"), i(1), t("</Grid>") }),
	s("typo", { t("<Typography>"), i(1), t("</Typography>") }),
}
ls.add_snippets("javascript", snippets)
ls.add_snippets("typescriptreact", snippets)
