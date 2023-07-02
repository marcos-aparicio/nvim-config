local M = require("mappings")
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_use_nerd_fonts = 1
vim.g.db_ui_force_echo_notifications = 1
vim.g.db_ui_save_location = os.getenv("HOME") .. "/.local/share/db_ui/connections.json"

M.nmap("<leader><leader>db", ":tab DBUI<CR>")
