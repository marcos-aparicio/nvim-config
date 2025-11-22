vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2

vim.o.clipboard = "unnamed,unnamedplus"
vim.o.hidden = true
vim.o.signcolumn = "yes"
vim.o.splitright = true

-- folding configs
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.autoread = true

vim.cmd("filetype plugin on")
vim.cmd("syntax on")

-- Set key mappings for F15 and F16 to emulate Ctrl-Tab and Ctrl-Shift-Tab
vim.api.nvim_set_keymap("n", "<F15>", "<C-Tab>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<F16>", "<C-S-Tab>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("i", "<F15>", "<C-Tab>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("i", "<F16>", "<C-S-Tab>", { silent = true, noremap = true })

-- Set the codes for F15 and F16 to be interpreted as keystrokes
vim.api.nvim_set_var("terminal_ansi_codes", { ["F15"] = "\27[1;5I", ["F16"] = "\27[1;6I" })

vim.g.loaded_netwr = 1
vim.g.loaded_netrwPlugin = 1

if vim.fn.has("nvim-0.10") == 1 then
	vim.opt.smoothscroll = true
	vim.opt.foldexpr = "v:lua.require'utils'.foldexpr()"
	vim.opt.foldmethod = "expr"
	vim.opt.foldtext = ""
else
	vim.opt.foldmethod = "indent"
	vim.opt.foldtext = "v:lua.require'utils'.foldtext()"
end

local function is_wsl()
	local version = vim.fn.readfile("/proc/version")[1] or ""
	return version:match("Microsoft") or version:match("WSL")
end
vim.g.is_wsl = is_wsl() and 1 or 0

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "gitcommit" },
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = { "en_us", "es", "fr" }
	end,
})

-- vim.opt_local.spell = true
-- vim.opt_local.spelllang = { "en_us", "es" }
