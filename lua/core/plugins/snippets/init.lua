return {
	"L3MON4D3/LuaSnip",
	version = "2.*",
	event = { "InsertEnter" },
	opts = function()
		local languages = {
			"markdown",
			"javascript",
			"html",
			"ledger",
			"sql",
			"json",
			"css",
			"octo",
			"python",
			"markdown",
			"php",
		}
		require("luasnip.loaders.from_vscode").lazy_load()
		for _, language in pairs(languages) do
			pcall(require, "core.plugins.snippets.settings." .. language)
		end
		return {}
	end,
}
