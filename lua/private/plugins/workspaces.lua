-- associative array for workspace names and the file to open when accessing the workspace (path related to the workspace main path)
-- @field [workspace Name]
-- @value [workspace file to open] Relative to workspace main path
local files_to_open = {
	nvim = "init.lua",
	awesome = "rc.lua",
	Finances = "2023.journal",
}
return files_to_open
