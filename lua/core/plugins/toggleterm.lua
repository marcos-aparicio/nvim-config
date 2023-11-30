local status_ok, toggleterm = pcall(require, "toggleterm")

if not status_ok then
	return
end
-- whenever you want to create multiple terminals add a number before the open mapping(if 2 doesn't work try 3)
toggleterm.setup({
	open_mapping = [[<c-;>]],
	autochdir = true,
})
