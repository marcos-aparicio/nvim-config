local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
	return
end

local s, t = ls.snippet, ls.text_node

local copilot_chat_snippets = {
	s(">bfvs", { t("> #buffers:visible") }),
	s(">bfall", { t("> #buffers:listed") }),
}

ls.add_snippets("copilot-chat", copilot_chat_snippets)
