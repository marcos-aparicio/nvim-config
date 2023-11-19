vim.opt.syntax = "on"
vim.o.termguicolors = true
vim.g.Powerline_symbols = "fancy"

vim.g.ayucolor = "dark"

local ok, _ = pcall(
	vim.cmd,
	[[
  colorscheme ayu
  hi Normal guibg=NONE ctermbg=NONE
  ]]
)
if not ok then
	vim.cmd([[
    colorscheme default
    hi Normal guibg=NONE ctermbg=NONE
  ]])
end
