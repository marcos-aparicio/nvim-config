local M = {}

local diary = require("core.plugins.markdown.diary")
local routines_index = require("core.plugins.markdown.routines-index")

-- Open a specific routine file
local function open_routine_file(filename)
  local root = diary.find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  local routines_dir = root .. "/routines"

  -- Create routines directory if it doesn't exist
  if vim.fn.isdirectory(routines_dir) == 0 then
    vim.fn.mkdir(routines_dir, "p")
  end

  local file_path = routines_dir .. "/" .. filename

  -- Create file if it doesn't exist
  if vim.fn.filereadable(file_path) == 0 then
    vim.fn.writefile({}, file_path)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(file_path))
end

-- Open routines directory with telescope finder
function M.open_routines_telescope()
  local root = diary.find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  local routines_dir = root .. "/routines"

  -- Create routines directory if it doesn't exist
  if vim.fn.isdirectory(routines_dir) == 0 then
    vim.fn.mkdir(routines_dir, "p")
  end

  local telescope = require("telescope.builtin")
  telescope.find_files({
    cwd = routines_dir,
    prompt_title = "Routines",
  })
end

-- Create a new routine with automatic name transformation
function M.create_new_routine()
  local root = diary.find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return
  end

  local routines_dir = root .. "/routines"

  -- Create routines directory if it doesn't exist
  if vim.fn.isdirectory(routines_dir) == 0 then
    vim.fn.mkdir(routines_dir, "p")
  end

  vim.ui.input({ prompt = "Enter routine name: " }, function(input)
    if not input or input:match("^%s*$") then
      vim.notify("Routine name cannot be empty", vim.log.levels.WARN)
      return
    end

    -- Transform name: trim, convert to lowercase, replace spaces with dashes
    local routine_name = vim.trim(input):lower():gsub("%s+", "-")
    local filename = routine_name .. ".md"
    local file_path = routines_dir .. "/" .. filename

    -- Check if file already exists
    if vim.fn.filereadable(file_path) == 1 then
      vim.notify("Routine '" .. filename .. "' already exists", vim.log.levels.WARN)
      return
    end

    -- Create file with h1 header
    local h1_title = input:gsub("^%s+", ""):gsub("%s+$", "") -- Trim the original input
    local content = { "# " .. h1_title, "" }
    vim.fn.writefile(content, file_path)

    -- Open the newly created file
    vim.cmd("edit " .. vim.fn.fnameescape(file_path))
    vim.notify("Created routine: " .. filename, vim.log.levels.INFO)

    -- Regenerate index
    routines_index.regenerate_index()
  end)
end

return M
