vim.opt.syntax = "on"
vim.o.termguicolors = true
vim.g.Powerline_symbols = "fancy"

vim.g.ayucolor = "dark"

local ok, _ = pcall(vim.cmd, "colorscheme ayu")

if not ok then
	vim.cmd([[ colorscheme default ]])
end

vim.cmd([[ hi Normal guibg=NONE ctermbg=NONE ]])
