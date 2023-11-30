local ok, _ = pcall(require, "lspconfig")
if not ok then
	print("lspconfig is not being loaded")
	return
end

require("plugin-confs.lsp.mason")
require("plugin-confs.lsp.handlers").setup()
require("plugin-confs.lsp.null-ls")
local ufo_ok, ufo = pcall(require, "ufo")
if not ufo_ok then
	return
end
ufo.setup()
