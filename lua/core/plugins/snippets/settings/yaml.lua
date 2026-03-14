local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
  return
end

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

--- Generate a random UUID v4
---
--- @return string uuid A randomly generated UUID v4 string
---
local function generate_uuid()
  local random = math.random
  local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
  return string.gsub(template, "[xy]", function(c)
    local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
    return string.format("%x", v)
  end)
end

local yaml_mappings = {
  s({
    trig = "bookmark",
    name = "Create a bookmark entry",
    desc = "Insert a bookmark with id, title, url, description, and tags",
  }, {
    t("- id: "),
    f(generate_uuid, {}),
    t({ "", "  title: " }),
    i(1, ""),
    t({ "", "  url: " }),
    i(2, ""),
    t({ "", "  description: ''" }),
    t({ "", "  tags:" }),
    t({ "", "  - " }),
    i(3, ""),
  }),
}

ls.add_snippets("yaml", yaml_mappings)
