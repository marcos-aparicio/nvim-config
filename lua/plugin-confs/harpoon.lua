local M = require("mappings")
local ok, harpoon_ui = pcall(require, "harpoon.ui")
if not ok then
	return
end
local ok2, harpoon_mark = pcall(require, "harpoon.mark")
if not ok2 then
	return
end

M.nmap("<leader>ss", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
M.nmap("<leader>sa", ":lua require('harpoon.mark').add_file()<CR>")
M.nmap("<leader>su", ":lua require('harpoon.ui').nav_file(1)<CR>")
M.nmap("<leader>si", ":lua require('harpoon.ui').nav_file(2)<CR>")
M.nmap("<leader>so", ":lua require('harpoon.ui').nav_file(3)<CR>")
M.nmap("<leader>sp", ":lua require('harpoon.ui').nav_file(4)<CR>")
