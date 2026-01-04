local globals = require("globals")
local M = {}

local function setup_markdown_features()
  local keymaps = require("core.plugins.markdown.keymaps")
  local commands = require("core.plugins.markdown.cmds")
  keymaps.setup_buffer_keymaps()
  commands.setup_buffer_commands()
end

function M.setup()
  -- For markdown files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = setup_markdown_features,
  })

  -- For files in notes workspace directory
  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = globals.notes_workspaces_dir .. "/*",
    callback = setup_markdown_features,
  })
end

return M
