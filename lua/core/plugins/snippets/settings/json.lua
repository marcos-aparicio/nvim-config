local prequire = require("utils").prequire
local ls = prequire("luasnip")
local date = require("date")

if not ls then
  return
end
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local function weird_date()
  -- local dateString = os.date("!%Y%m%d - %H%M")
  -- return dateString
  --
  local d = date(true):tolocal("America/Toronto")
  return d:fmt("%Y%m%d - %H%M")
end

-- Hledger tags
ls.add_snippets("json", {
  s("stencil", {
    t({ weird_date() .. " " }),
  }),
})
