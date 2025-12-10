local globals = require "globals"
local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      local path = vim.api.nvim_buf_get_name(args.buf)
      if not (
            ft == "markdown" or vim.startswith(path, globals.notes_workspaces_dir)
            or (path == "" and vim.startswith(vim.fn.getcwd(), globals.notes_workspaces_dir))
          ) then
        return
      end
      local keymaps = require("core.plugins.markdown.keymaps")
      local commands = require("core.plugins.markdown.cmds")
      keymaps.setup_buffer_keymaps()
      commands.setup_buffer_commands()
    end,
  })
end

return M
