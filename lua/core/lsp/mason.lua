local servers = require("core.lsp.servers")
	or {
		"lua_ls",
		"emmet_language_server",
		"eslint",
		"marksman",
		"volar",
	}

local ok_mason, mason = pcall(require, "mason")
if not ok_mason then
	return
end
local ok_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
if not ok_lsp then
	return
end

mason.setup()
mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
if not ok_lspconfig then
	return
end

local handlers = require("core.lsp.handlers")
local default_opts = {
	on_attach = handlers.on_attach,
	capabilities = handlers.capabilities,
}

for _, server_name in pairs(servers) do
	local server = vim.split(server_name, "@")[1]
	local opts = vim.tbl_deep_extend("force", {}, default_opts)

	local has_custom, custom_opts = pcall(require, "core.lsp.settings." .. server)
	if has_custom then
		opts = vim.tbl_deep_extend("force", opts, custom_opts)
	end

	lspconfig[server].setup(opts)
end
