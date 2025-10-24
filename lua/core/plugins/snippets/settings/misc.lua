local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
	return
end

local s, t = ls.snippet, ls.text_node

local copilot_chat_snippets = {
	s(">bfvs", { t("> #buffers:visible") }),
	s(">bfall", { t("> #buffers:listed") }),
	s("son4", { t("$claude-sonnet-4") }),
	s("arb", { t("#dir_tree") }),
	s(",obs", { t("@obsidian") }),
  s(",daisy",{ t("#url:https://daisyui.com/llms.txt")})
}

ls.add_snippets("copilot-chat", copilot_chat_snippets)
