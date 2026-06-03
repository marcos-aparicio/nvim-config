local M = {}

local collections = require("core.plugins.markdown.collections")

-- Open tracking directory with telescope finder
function M.open_tracking_telescope()
  collections.open_telescope("tracking")
end

-- Create a new tracking entry with automatic name transformation
function M.create_new_tracking()
  collections.create_new_entry("tracking")
end

return M
