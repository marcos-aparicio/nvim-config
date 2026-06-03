local M = {}

local collections = require("core.plugins.markdown.collections")

-- Open random directory with telescope finder
function M.open_random_telescope()
  collections.open_telescope("random")
end

-- Create a new random entry with automatic name transformation
function M.create_new_random()
  collections.create_new_entry("random")
end

return M
