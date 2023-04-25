vim.opt.syntax = "on"
vim.o.termguicolors = true

vim.g.airline_extensions_tabline_left_sep = ""
vim.g.airline_extensions_tabline_left_sep = ""

vim.g.airline_extensions_tabline_left_alt_sep = ""
vim.g.airline_extensions_tabline_left_alt_sep = ""

vim.g.airline_left_sep = ""
vim.g.airline_left_sep = ""

vim.g.airline_right_sep = ""
vim.g.airline_right_sep = ""

vim.g.airline_powerline_fonts = 1
vim.g["airline#extensions#tabline#enabled"] = 0
vim.g.Powerline_symbols = "fancy"

vim.g.airline_theme = "ayu_dark"
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
