local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
	return
end

local s, t, f = ls.snippet, ls.text_node, ls.function_node

local function create_smart_snippets(trigger, text)
  return {
    s(trigger, { t(text) }),
    s("," .. trigger, { t("> " .. text) })
  }
end

local copilot_chat_snippets = {}

-- Add all snippets for each trigger
local triggers = {
  {"bfvs", "#buffers:visible"},
  {"bfall", "#buffers:listed"},
  {"son4", "$claude-sonnet-4"},
  {"arb", "#dir_tree"},
  {"obs", "@obsidian"},
  {"daisy", "#url:https://daisyui.com/llms.txt"},
}

for _, trigger_data in ipairs(triggers) do
  local trigger, text = trigger_data[1], trigger_data[2]
  local snippets = create_smart_snippets(trigger, text)
  for _, snippet in ipairs(snippets) do
    table.insert(copilot_chat_snippets, snippet)
  end
end

ls.add_snippets("copilot-chat", copilot_chat_snippets)
--
-- local copilot_chat_snippets = {
-- 	s("bfvs", { t("#buffers:visible") }),
-- 	s("bfall", { t("#buffers:listed") }),
-- 	s("son4", { t("$claude-sonnet-4") }),
-- 	s("arb", { t("#dir_tree") }),
-- 	s(",obs", { t("@obsidian") }),
--   s(",daisy",{ t("#url:https://daisyui.com/llms.txt")})
-- }
--
-- ls.add_snippets("copilot-chat", copilot_chat_snippets)
