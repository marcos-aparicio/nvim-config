local prequire = require("utils").prequire
local ls = prequire("luasnip")
if not ls then
	return
end

local languages = {
	"vimwiki",
	"javascript",
	"ledger",
	"sql",
	"octo",
	"python",
	"markdown",
}

for _, language in pairs(languages) do
	prequire("plugin-confs.luasnip.settings." .. language)
end
