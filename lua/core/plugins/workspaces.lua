function fileToOpenPerProject()
  local workspaces = require("workspaces")
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

return {
  "natecraddock/workspaces.nvim",
  opts = {
	hooks = {
		open = {
			fileToOpenPerProject,
			"Telescope find_files",
		},
	},
}}
