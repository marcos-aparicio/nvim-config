local function safe_require(module)
	local ok, result = pcall(require, module)
	if ok then
		return result
	else
		return nil
	end
end

local servers = safe_require("private.plugins.servers") or {}

local mason = safe_require("mason")
if not mason then
	return
end

local mason_lspconfig = safe_require("mason-lspconfig")
if not mason_lspconfig then
	return
end

mason.setup()
mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig = safe_require("lspconfig")
if not lspconfig then
	return
end

local opts = {}

for _, server in pairs(servers) do
	opts = {
		on_attach = require("core.lsp.handlers").on_attach,
		capabilities = require("core.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	local require_ok, conf_opts = pcall(require, "core.lsp.settings." .. server)
	if require_ok then
		opts = vim.tbl_deep_extend("force", conf_opts, opts)
	end

	lspconfig[server].setup(opts)
end
