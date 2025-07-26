local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
	return
end

local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node

local function font_size_snippet(args)
	local input = args[1][1]
	local a, b, c = input:match("^%s*(%d+)%s*,?%s*(%d*)%s*,?%s*(%d*)%s*$")

	a = tonumber(a)

	b = tonumber(b)
	c = tonumber(c)

	-- Only A provided: output simple font-size
	if not b or not c or b == 0 or c == 0 then
		return string.format("font-size: %dpx;", a or 0)
	end

	-- Clamp logic
	local min_vw = 320
	local max_vw = 1280
	local slope = (c - b) / (max_vw - min_vw)
	local slope_vw = slope * 100
	local intercept = b - slope * min_vw

	-- Format intercept: wrap in parentheses if negative
	local intercept_str = intercept < 0 and string.format("(%.3fpx)", intercept) or string.format("%.3fpx", intercept)

	return string.format("font-size: clamp(%dpx, %.3fvw + %s, %dpx);", b, slope_vw, intercept_str, c)
end

local snippets = {
	s("fuen", {
		i(1, "16,18,24"),
		f(font_size_snippet, { 1 }),
	}),
}

ls.add_snippets("css", snippets)
-- local languages = {
--   "css", "sass", "scss", "html", "javascript", "javascriptreact", "typescript", "typescriptreact"
-- }
--
-- for lang in languages do
--   ls.add_snippets(lang, snippets)
-- end
