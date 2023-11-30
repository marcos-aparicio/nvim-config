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
		"less",
		"sass",
		"scss",
		"svelte",
		"pug",
		-- "typescriptreact",
		"vue",
	},
	init_options = {
		--- @type table<string, any> https://docs.emmet.io/customization/preferences/
		preferences = {},
		--- @type "always" | "never" defaults to `"always"`
		showexpandedabbreviation = "always",
		--- @type boolean defaults to `true`
		showabbreviationsuggestions = true,
		--- @type boolean defaults to `false`
		showsuggestionsassnippets = true,
		--- @type table<string, any> https://docs.emmet.io/customization/syntax-profiles/
		syntaxprofiles = {},
		--- @type table<string, string> https://docs.emmet.io/customization/snippets/#variables
		variables = {},
		--- @type string[]
		excludelanguages = {},
	},
}
