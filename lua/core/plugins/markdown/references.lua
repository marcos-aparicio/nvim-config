local M = {}

local collections = require("core.plugins.markdown.collections")

-- Open tracking directory with telescope finder
function M.open_references_telescope()
  collections.open_telescope("references")
end

-- Create a new tracking entry with automatic name transformation
function M.create_new_reference()
  collections.create_new_entry("references")
end

return M
