-- local lspconfig = require("lspconfig")
-- local configs = require("lspconfig/configs")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

return {
	capabilities = capabilities,
	filetypes = {
		"css",
		"eruby",
		"html",
		"javascript",
		"javascriptreact",
		"php",
		"less",
		"sass",
		"scss",
		"mustache",
		"svelte",
		"blade",
		"pug",
		-- "typescriptreact",
		"vue",
	},
	init_options = {
		--- @type table<string, any> https://docs.emmet.io/customization/preferences/
		preferences = {},
		--- @type "always" | "never" defaults to `"always"`
		showExpandedAbbreviation = "always",
		--- @type boolean defaults to `true`
		showAbbreviationSuggestions = true,
		--- @type boolean defaults to `false`
		showSuggestionsAsSnippets = true,
		--- @type table<string, any> https://docs.emmet.io/customization/syntax-profiles/
		syntaxProfiles = {
			html = { self_closing_tag = true },
		},
		--- @type table<string, string> https://docs.emmet.io/customization/snippets/#variables
		variables = {},
		--- @type string[]
		excludeLanguages = {},
	},
}
