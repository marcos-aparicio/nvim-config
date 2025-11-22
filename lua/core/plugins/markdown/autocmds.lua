local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      local keymaps = require("core.plugins.markdown.keymaps")
      local commands =  require("core.plugins.markdown.cmds")
      keymaps.setup_buffer_keymaps()
      commands.setup_buffer_commands()
    end,
  })
end

return M
