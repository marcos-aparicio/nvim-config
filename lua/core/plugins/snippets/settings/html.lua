local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
  return
end

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local snippets = {
  s("handcom", { t("{!-- "), i(1), t("--}}") }),
}
ls.add_snippets("html", snippets)
