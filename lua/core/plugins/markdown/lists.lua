local M = {}

local collections = require("core.plugins.markdown.collections")
local diary = require("core.plugins.markdown.diary")

-- Convenience function to open specific list file
local function open_list_file(filename)
  collections.open_file("lists", filename)
end

-- Ordered fallback chain of candidate inbox files, relative to the obsidian root.
-- The last entry (lists/inbox.md) is always a valid fallback.
local function get_inbox_candidates(root)
  return {
    root .. "/memory/gtd/inbox.md",
    root .. "/lists/inbox.md",
  }
end

-- Resolve the inbox path by picking the first candidate whose parent directory
-- already exists, falling back to the last candidate (lists/inbox.md) otherwise.
local function resolve_inbox_path(root)
  local candidates = get_inbox_candidates(root)
  for i, candidate in ipairs(candidates) do
    local is_last = i == #candidates
    local dir = vim.fn.fnamemodify(candidate, ":h")
    if is_last or vim.fn.isdirectory(dir) == 1 then
      return candidate
    end
  end
end

-- Open (creating if necessary) a file at an arbitrary absolute path
local function open_file_creating(path)
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
  if vim.fn.filereadable(path) == 0 then
    vim.fn.writefile({}, path)
  end
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

-- Open next.md
function M.open_next()
  open_list_file("next.md")
end

-- Open someday-maybe.md
function M.open_someday_maybe()
  open_list_file("someday-maybe.md")
end

-- Open inbox.md, following the same fallback chain as append_to_inbox
function M.open_inbox()
  local root = diary.find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  open_file_creating(resolve_inbox_path(root))
end

-- Open waiting-to.md
function M.open_waiting_to()
  open_list_file("waiting-to.md")
end

-- Open tickler.md
function M.open_tickler()
  open_list_file("tickler.md")
end

-- Open lists directory with telescope finder
function M.open_lists_telescope()
  collections.open_telescope("lists")
end

-- Create a new list with automatic name transformation
function M.create_new_list()
  collections.create_new_entry("lists")
end

-- Append item to inbox list
function M.append_to_inbox()
  local root = diary.find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  local inbox_path = resolve_inbox_path(root)

  vim.ui.input({ prompt = "Add to inbox: " }, function(input)
    if not input or input:match("^%s*$") then
      return
    end

    -- Read current inbox content
    local lines = {}
    if vim.fn.filereadable(inbox_path) == 1 then
      lines = vim.fn.readfile(inbox_path)
    else
      -- Create inbox dir and content if it doesn't exist
      local inbox_dir = vim.fn.fnamemodify(inbox_path, ":h")
      if vim.fn.isdirectory(inbox_dir) == 0 then
        vim.fn.mkdir(inbox_dir, "p")
      end
      lines = { "# inbox", "" }
    end

     -- Append the new item with date
     local date_str = os.date("%c")
     table.insert(lines, "- (" .. date_str .. ") " .. input)

    -- Write back to file
    vim.fn.writefile(lines, inbox_path)
    vim.notify("Added to inbox: " .. input, vim.log.levels.INFO)
  end)
end

return M
