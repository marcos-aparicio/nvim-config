local ok, workspaces = pcall(require, "workspaces")
if not ok then
	return
end
workspaces.setup({
	hooks = {
		open = { "NvimTreeRefresh", "Telescope find_files" },
	},
})
