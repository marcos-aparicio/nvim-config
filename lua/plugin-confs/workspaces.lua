local ok, workspaces = pcall(require, "workspaces")
workspaces.setup({
	hooks = {
		open = { "NvimTreeRefresh", "Telescope find_files" },
	},
})
