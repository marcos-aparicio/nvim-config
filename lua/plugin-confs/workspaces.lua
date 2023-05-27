local ok, workspaces = pcall(require, "workspaces")
if not ok then
	return
end

function fileToOpenPerProject()
	local current_workspace = workspaces.name()
	local ok, files_to_open = pcall(require, "plugin-confs.workspaces-private-config")

	if not ok then
		return
	end

	local file_to_open = files_to_open[current_workspace]
	if file_to_open == nil then
		return
	end
	vim.api.nvim_command("e " .. file_to_open)
end

workspaces.setup({
	hooks = {
		open = {
			fileToOpenPerProject,
			"NvimTreeRefresh",
			"NvimTreeOpen",
			function()
				vim.api.nvim_command("wincmd p")
			end,
		},
	},
})
