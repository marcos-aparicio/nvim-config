local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
  return
end

local s, t, i, f = ls.snippet, ls.text_node, ls.insert_node, ls.function_node

local MIN_VW_CLAMP, MAX_VW_CLAMP = 320, 1240

local function clamp_logic(args, parent_args)
  local min = tonumber(args[1][1])
  local max = tonumber(args[2][1])
  if not min or not max then
    return ""
  end

  local min_vw = tonumber(parent_args.captures[2]) or MIN_VW_CLAMP
  local max_vw = tonumber(parent_args.captures[3]) or MAX_VW_CLAMP

  local slope = (max - min) / (max_vw - min_vw)
  local slope_vw = slope * 100
  local intercept = min - slope * min_vw
  local intercept_str = intercept < 0 and string.format("(%.3fpx)", intercept)
    or string.format("%.3fpx", intercept)
  return string.format("%s + %.3fvw", intercept_str, slope_vw)
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
    f(function(_, snip)
      return snip.captures[1] .. ": "
    end, {}),
    i(1),
    t({ "; /* fallback */", "" }),
    f(function(_, snip)
      return snip.captures[1] .. ": clamp("
    end, {}),
    i(2, "min size(in px)"),
    t("px, "),
    f(clamp_logic, { 2, 3 }),
    t(", "),
    i(3, "max size(in px)"),
    t("px); "),
    f(function(_, snip)
      local min_vw = tonumber(snip.captures[2]) or MIN_VW_CLAMP
      local max_vw = tonumber(snip.captures[3]) or MAX_VW_CLAMP
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
    f(function(_, snip)
      return snip.captures[1] .. ": "
    end, {}),
    i(1),
    t({ "; /* fallback */", "" }),
    f(function(_, snip)
      return snip.captures[1] .. ": unquote('clamp("
    end, {}),
    i(2, "min size(in px)"),
    t("px, "),
    f(clamp_logic, { 2, 3 }),
    t(", "),
    i(3, "max size(in px)"),
    t("px)'); "),
    f(function(_, snip)
      local min_vw = tonumber(snip.captures[2]) or MIN_VW_CLAMP
      local max_vw = tonumber(snip.captures[3]) or MAX_VW_CLAMP
      return string.format(
        "/* Property will dynamically change between %dpx and %dpx of viewport width */",
        min_vw,
        max_vw
      )
    end),
  }),
}

ls.add_snippets("html", css_snippets)
ls.add_snippets("css", css_snippets)
ls.add_snippets("scss", scss_snippets)
