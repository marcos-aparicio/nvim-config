local ok, workspaces = pcall(require, "workspaces")
workspaces.setup({
	hooks = {
		open = "NvimTreeOpen",
	},
})
