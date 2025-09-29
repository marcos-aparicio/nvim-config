local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      local keymaps = require("core.plugins.markdown.keymaps")
      keymaps.setup_buffer_keymaps()
    end,
  })
end

return M
