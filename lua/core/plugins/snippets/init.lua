return {
	"L3MON4D3/LuaSnip",
	dependencies = { "hrsh7th/nvim-cmp", "rafamadriz/friendly-snippets" },
	config = function()
		local languages = {
			"markdown",
			"javascript",
			"ledger",
			"sql",
			"octo",
			"python",
			"markdown",
			"php",
		}
		for _, language in pairs(languages) do
			pcall(require, "core.plugins.snippets.settings." .. language)
		end
	end,
}
