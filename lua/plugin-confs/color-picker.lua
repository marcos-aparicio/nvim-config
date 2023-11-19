local M = require("mappings")
local ok, color_picker = pcall(require, "color-picker")
if not ok then
	return
end
color_picker.setup()
M.nmap("<C-c>", ":PickColor<CR>")
M.imap("<C-c>", ":PickColorInsert<CR>")
