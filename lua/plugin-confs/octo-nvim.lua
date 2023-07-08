local M = require("mappings")
local ok, octo = pcall(require, "octo")
if not ok then
	return
end
octo.setup()
M.nmap("<leader>opl", ":Octo pr list<CR>")
M.nmap("<leader>ope", ":Octo pr edit<space>")
M.nmap("<leader>opr", ":Octo pr reload<CR>")
M.nmap("<leader>or", ":Octo review<space>")
