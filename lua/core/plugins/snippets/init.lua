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
			"misc",
		}
		require("luasnip.loaders.from_vscode").lazy_load()
		for _, language in pairs(languages) do
			pcall(require, "core.plugins.snippets.settings." .. language)
		end

		-- Add choice node navigation
		vim.keymap.set({"i", "s"}, "<C-n>", function()
			if require("luasnip").choice_active() then
				require("luasnip").change_choice(1)
			end
		end)
		vim.keymap.set({"i", "s"}, "<C-p>", function()
			if require("luasnip").choice_active() then
				require("luasnip").change_choice(-1)
			end
		end)
		return {}
	end,
}
