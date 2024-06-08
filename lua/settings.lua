HOME = os.getenv("HOME")

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	pattern = "/home/marcos/Finances/*.journal",
	desc = "Format journal files after saving, it should be in the ledger path",
	callback = function()
		local keyword = vim.fn.system('grep "include.*journal" ' .. vim.fn.expand("%:p"))
		if vim.bo.filetype == "ledger" and keyword ~= "" then
			print("Not formatting since it is an index file or includes include")
		else
			vim.api.nvim_command(
				"!sh " .. os.getenv("HOME") .. "/.local/privbin/reorder-journal.sh " .. vim.fn.expand("%:p")
			)
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.md",
	desc = "Conceal arrows in markdown files",
	callback = function()
		vim.api.nvim_command('call matchadd("Conceal", "<--", 9999, -1, {"conceal": "⬅"})')
		vim.api.nvim_command('call matchadd("Conceal", "-->", 9999, -1, {"conceal": "➡"})')
	end,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = "*",
	desc = "Strip trailing whitespace before saving",
	callback = function()
		vim.fn.execute("%s/\\s\\+$//e")
	end,
})

vim.api.nvim_create_augroup("Extensions", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.hurl",
	group = "Extensions",
	callback = function()
		vim.bo.filetype = "hurl"
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "mysql",
	group = "Extensions",
	callback = function()
		vim.bo.completefunc = "complete_sql"
		vim.bo.omnifunc = "omni_sql"
		vim.bo.filetype = "sql"
	end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "todo.txt",
	group = "Extensions",
	callback = function()
		vim.bo.filetype = "todotxt"
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	pattern = "*",
	group = "Extensions",
	callback = function()
		if vim.bo.buftype == "terminal" then
			vim.api.nvim_command("startinsert")
		end
	end,
})

vim.api.nvim_create_autocmd({ "ColorScheme" }, {
	pattern = "*",
	callback = function()
		vim.api.nvim_command("highlight SignColumn guibg=NONE")
	end,
})

vim.g.mapleader = " "
vim.g.pyton3_host_prog = "/usr/bin/python3"
vim.g.markdown_folding = true

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

-- settings required for vimwiki to work
vim.o.compatible = false
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
