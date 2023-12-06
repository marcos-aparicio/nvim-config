local function object_assign(t1, t2)
	for key, value in pairs(t2) do
		t1[key] = value
	end

	return t1
end

local servers = {
	"lua_ls",
	"csharp_ls",
	"html",
	"tsserver",
	"emmet_language_server",
	"pyright",
	"grammarly",
	"eslint",
	"intelephense",
}

local ok, mason = pcall(require, "mason")

if not ok then
	return
end

local masonlsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")

if not masonlsp_ok then
	return
end

mason.setup()
mason_lspconfig.setup({
	ensure_installed = servers,
	automatic_installation = true,
})

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")

if not lspconfig_ok then
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
