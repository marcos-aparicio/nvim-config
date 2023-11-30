local M = require("mappings")
local ok, harpoon_ui = pcall(require, "harpoon.ui")
if not ok then
	return
end
local ok2, harpoon_mark = pcall(require, "harpoon.mark")
if not ok2 then
	return
end

-- M.nmap("<leader>ds", ":lua require('harpoon.ui').toggle_quick_menu()<CR>")
-- M.nmap("<leader>da", ":lua require('harpoon.mark').add_file()<CR>")
-- M.nmap("<leader>du", ":lua require('harpoon.ui').nav_file(1)<CR>")
-- M.nmap("<leader>di", ":lua require('harpoon.ui').nav_file(2)<CR>")
-- M.nmap("<leader>do", ":lua require('harpoon.ui').nav_file(3)<CR>")
-- M.nmap("<leader>dp", ":lua require('harpoon.ui').nav_file(4)<CR>")
