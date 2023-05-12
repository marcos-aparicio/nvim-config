HOME = os.getenv("HOME")

vim.cmd([[
	augroup StripTrailingWhiteSpace
		au!
		au BufWritePre * %s/\s\+$//e
	augroup END

  augroup TerminalMode
    autocmd!
    autocmd BufEnter * if &buftype == 'terminal' | :startinsert | endif
  augroup END
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
  augroup transparent_signs
    au!
    autocmd ColorScheme * highlight SignColumn guibg=NONE
  augroup END
]])
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

-- Set key mappings for F15 and F16 to emulate Ctrl-Tab and Ctrl-Shift-Tab
vim.api.nvim_set_keymap("n", "<F15>", "<C-Tab>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<F16>", "<C-S-Tab>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("i", "<F15>", "<C-Tab>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("i", "<F16>", "<C-S-Tab>", { silent = true, noremap = true })

-- Set the codes for F15 and F16 to be interpreted as keystrokes
vim.api.nvim_set_var("terminal_ansi_codes", { ["F15"] = "\27[1;5I", ["F16"] = "\27[1;6I" })

vim.g.loaded_netwr = 1
vim.g.loaded_netrwPlugin = 1

-- for allowing auto_close
-- nvim-tree is also there in modified buffers so this function filter it out
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
-- 	pattern = "NvimTree_*",
-- 	callback = function()
-- 		local layout = vim.api.nvim_call_function("winlayout", {})
-- 		if
-- 			layout[1] == "leaf"
-- 			and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree"
-- 			and layout[3] == nil
-- 		then
-- 			vim.cmd("confirm quit")
-- 		end
-- 	end,
-- })
