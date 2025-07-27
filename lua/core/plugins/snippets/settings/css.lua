local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
	return
end

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local clamp_logic = function(args, parent_args, user_args)
	local min = args[1][1]
	local max = args[2][1]

	local ok, min_px = pcall(tonumber, min)
	if not ok or min_px == nil then
		return ""
	end
	local ok2, max_px = pcall(tonumber, max)
	if not ok2 or max_px == nil then
		return ""
	end

	-- Clamp logic
	local min_vw = 320
	local max_vw = 1240
	-- Calculate slope and intercept
	local slope = (max_px - min_px) / (max_vw - min_vw)
	local slope_vw = slope * 100
	local intercept = min_px - slope * min_vw

	-- Format intercept with px and parentheses if negative
	local intercept_str = intercept < 0 and string.format("(%.3fpx)", intercept) or string.format("%.3fpx", intercept)

	-- Format final clamp string
	local clamp = string.format("%s + %.3fvw", intercept_str, slope_vw)

	return clamp
	-- return min .. " " .. max .. " px"
end
local css_snippets = {
	s("fuen", {
		t("font-size: "),
		i(1, "fallback font size(in px)"),
		t({ "px;", "font-size: clamp(" }),
		i(2, "min size(in px)"),
		t("px, "),
		f(clamp_logic, { 2, 3 }),
		t(", "),
		i(3, "max size(in px)"),
		t("px);"),
	}),
}
local scss_snippets = {

	s("fuen", {
		t("font-size: "),
		i(1, "fallback font size(in px)"),
		t({ "px;", "font-size: unquote('clamp(" }),
		i(2, "min size(in px)"),
		t("px, "),
		f(clamp_logic, { 2, 3 }),
		t(", "),
		i(3, "max size(in px)"),
		t("px)');"),
	}),
}

ls.add_snippets("css", css_snippets)
ls.add_snippets("scss", scss_snippets)
