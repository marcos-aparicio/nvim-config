local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
	return
end

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local MIN_VW_CLAMP = 320
local MAX_VW_CLAMP = 1240

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
	local min_vw = MIN_VW_CLAMP
	local max_vw = MAX_VW_CLAMP

	local ok3, custom_min_vw = pcall(tonumber, parent_args.captures[2])
	if ok3 and custom_min_vw ~= nil then
		min_vw = custom_min_vw
	end

	local ok4, custom_max_vw = pcall(tonumber, parent_args.captures[3])
	if ok4 and custom_max_vw ~= nil then
		max_vw = custom_max_vw
	end

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
	s({ trig = "clamp:([%w_-]+):?([%d]*):?([%d]*)", regTrig = true }, {
		f(function(args, snip)
			return snip.captures[1] .. ": "
		end, {}),
		i(1),
		t({ "; /* fallback */", "" }),
		f(function(args, snip)
			return snip.captures[1] .. ": clamp("
		end, {}),
		i(2, "min size(in px)"),
		t("px, "),
		f(clamp_logic, { 2, 3 }),
		t(", "),
		i(3, "max size(in px)"),
		t("px); "),
		f(function(args, snip)
			-- Clamp logic
			local min_vw = MIN_VW_CLAMP
			local max_vw = MAX_VW_CLAMP

			local ok3, custom_min_vw = pcall(tonumber, snip.captures[2])
			if ok3 and custom_min_vw ~= nil then
				min_vw = custom_min_vw
			end

			local ok4, custom_max_vw = pcall(tonumber, snip.captures[3])
			if ok4 and custom_max_vw ~= nil then
				max_vw = custom_max_vw
			end
			return string.format(
				"/* Property will dynamically change between %dpx and %dpx of viewport width */",
				min_vw,
				max_vw
			)
		end),
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
	s({ trig = "clamp:([%w_-]+):?([%d]*):?([%d]*)", regTrig = true }, {
		f(function(args, snip)
			return snip.captures[1] .. ": "
		end, {}),
		i(1),
		t({ "; /* fallback */", "" }),
		f(function(args, snip)
			return snip.captures[1] .. ": unquote('clamp("
		end, {}),
		i(2, "min size(in px)"),
		t("px, "),
		f(clamp_logic, { 2, 3 }),
		t(", "),
		i(3, "max size(in px)"),
		t("px)'); "),
		f(function(args, snip)
			-- Clamp logic
			local min_vw = MIN_VW_CLAMP
			local max_vw = MAX_VW_CLAMP

			local ok3, custom_min_vw = pcall(tonumber, snip.captures[2])
			if ok3 and custom_min_vw ~= nil then
				min_vw = custom_min_vw
			end

			local ok4, custom_max_vw = pcall(tonumber, snip.captures[3])
			if ok4 and custom_max_vw ~= nil then
				max_vw = custom_max_vw
			end
			return string.format(
				"/* Property will dynamically change between %dpx and %dpx of viewport width */",
				min_vw,
				max_vw
			)
		end),
	}),
}

ls.add_snippets("css", css_snippets)
ls.add_snippets("scss", scss_snippets)
