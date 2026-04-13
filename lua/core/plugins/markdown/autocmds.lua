local globals = require("globals")
local M = {}

local function setup_markdown_features()
  local keymaps = require("core.plugins.markdown.keymaps")
  local commands = require("core.plugins.markdown.cmds")
  keymaps.setup_buffer_keymaps()
  commands.setup_buffer_commands()
end

local function setup_lists_index_watcher()
  local lists_index = require("core.plugins.markdown.lists-index")
  local diary = require("core.plugins.markdown.diary")

  -- Watch for changes in lists directory
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*/lists/*.md",
    callback = function()
      -- Regenerate index when any list file is saved
      lists_index.regenerate_index()
    end,
  })

  -- Watch for changes in tickler directory
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*/lists/tickler/*.md",
    callback = function()
      -- Regenerate tickler index when any tickler file is saved
      lists_index.regenerate_tickler_index()
    end,
  })

  -- Also watch for file creation/deletion by monitoring BufEnter in lists
  vim.api.nvim_create_autocmd("DirChanged", {
    callback = function()
      local root = diary.find_obsidian_root()
      if root then
        local lists_dir = root .. "/lists"
        if vim.fn.isdirectory(lists_dir) == 1 then
          lists_index.regenerate_index()
        end
        local tickler_dir = root .. "/lists/tickler"
        if vim.fn.isdirectory(tickler_dir) == 1 then
          lists_index.regenerate_tickler_index()
        end
      end
    end,
  })
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

  -- Setup lists index watcher
  setup_lists_index_watcher()
end

return M
