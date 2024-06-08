local autocmd = vim.api.nvim_create_autocmd
local nvim_cmd = vim.api.nvim_command
local fmt = string.format

autocmd({ "BufWritePost" }, {
	desc = "Format journal files after saving, it should be in the ledger path",
	pattern = "/home/marcos/Finances/*.journal",
	callback = function()
		local keyword = vim.fn.system('grep "include.*journal" ' .. vim.fn.expand("%:p"))

		if vim.bo.filetype == "ledger" and keyword ~= "" then
			print("Not formatting since it is an index file or includes include")
			return
		end

		nvim_cmd(fmt("!sh %s/.local/privbin/reorder-journal.sh %s", os.getenv("HOME"), vim.fn.expand("%:p")))
	end,
})

autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.md",
	desc = "Conceal arrows in markdown files",
	callback = function()
		nvim_cmd('call matchadd("Conceal", "<--", 9999, -1, {"conceal": "⬅"})')
		nvim_cmd('call matchadd("Conceal", "-->", 9999, -1, {"conceal": "➡"})')
	end,
})

autocmd({ "BufWritePre" }, {
	pattern = "*",
	desc = "Strip trailing whitespace before saving",
	callback = function()
		vim.fn.execute("%s/\\s\\+$//e")
	end,
})

vim.api.nvim_create_augroup("Extensions", { clear = true })
autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.hurl",
	group = "Extensions",
	callback = function()
		vim.bo.filetype = "hurl"
	end,
})

autocmd({ "FileType" }, {
	pattern = "mysql",
	group = "Extensions",
	callback = function()
		vim.bo.completefunc = "complete_sql"
		vim.bo.omnifunc = "omni_sql"
		vim.bo.filetype = "sql"
	end,
})

autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "todo.txt",
	group = "Extensions",
	callback = function()
		vim.bo.filetype = "todotxt"
	end,
})

autocmd({ "BufEnter" }, {
	pattern = "*",
	group = "Extensions",
	callback = function()
		if vim.bo.buftype == "terminal" then
			nvim_cmd("startinsert")
		end
	end,
})

autocmd({ "ColorScheme" }, {
	pattern = "*",
	callback = function()
		nvim_cmd("highlight SignColumn guibg=NONE")
	end,
})
