local M = {}

local collections = require("core.plugins.markdown.collections")

-- Open routines directory with telescope finder
function M.open_routines_telescope()
  collections.open_telescope("routines")
end

-- Create a new routine with automatic name transformation
function M.create_new_routine()
  collections.create_new_entry("routines")
end

return M
