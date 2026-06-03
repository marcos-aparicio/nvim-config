local M = {}

local diary = require("core.plugins.markdown.diary")

-- Collection configurations
local collections_config = {
  lists = {
    dir_name = "lists",
    has_index = true,
    index_module = "core.plugins.markdown.lists-index",
  },
  routines = {
    dir_name = "routines",
    has_index = true,
    index_module = "core.plugins.markdown.routines-index",
  },
  tracking = {
    dir_name = "tracking",
    has_index = true,
    index_module = "core.plugins.markdown.tracking-index",
  },
  random = {
    dir_name = "random",
    has_index = false,
  },
}

-- Get config for a collection
local function get_config(collection_name)
  local config = collections_config[collection_name]
  if not config then
    vim.notify("Unknown collection: " .. collection_name, vim.log.levels.ERROR)
    return nil
  end
  return config
end

-- Get the full path to a collection directory
local function get_collection_dir(collection_name)
  local root = diary.find_obsidian_root()
  if not root then
    vim.notify("Could not find .obsidian directory in parent folders", vim.log.levels.ERROR)
    return nil
  end

  local config = get_config(collection_name)
  if not config then
    return nil
  end

  local collection_dir = root .. "/" .. config.dir_name

  -- Create directory if it doesn't exist
  if vim.fn.isdirectory(collection_dir) == 0 then
    vim.fn.mkdir(collection_dir, "p")
  end

  return collection_dir
end

-- Open a specific file in a collection
function M.open_file(collection_name, filename)
  local collection_dir = get_collection_dir(collection_name)
  if not collection_dir then
    return
  end

  local file_path = collection_dir .. "/" .. filename

  -- Create file if it doesn't exist
  if vim.fn.filereadable(file_path) == 0 then
    vim.fn.writefile({}, file_path)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(file_path))
end

-- Open collection directory with telescope finder
function M.open_telescope(collection_name)
  local collection_dir = get_collection_dir(collection_name)
  if not collection_dir then
    return
  end

  local telescope = require("telescope.builtin")
  telescope.find_files({
    cwd = collection_dir,
    prompt_title = collection_name:gsub("^%l", string.upper),
  })
end

-- Create a new entry in a collection with automatic name transformation
function M.create_new_entry(collection_name)
  local collection_dir = get_collection_dir(collection_name)
  if not collection_dir then
    return
  end

  local config = get_config(collection_name)
  if not config then
    return
  end

  local prompt_text = "Enter " .. collection_name:sub(1, -2) .. " name: " -- Remove trailing 's'
  if collection_name == "random" then
    prompt_text = "Enter random entry name: "
  end

  vim.ui.input({ prompt = prompt_text }, function(input)
    if not input or input:match("^%s*$") then
      vim.notify(collection_name:gsub("^%l", string.upper) .. " name cannot be empty", vim.log.levels.WARN)
      return
    end

    -- Transform name: trim, convert to lowercase, replace spaces with dashes
    local entry_name = vim.trim(input):lower():gsub("%s+", "-")
    local filename = entry_name .. ".md"
    local file_path = collection_dir .. "/" .. filename

    -- Check if file already exists
    if vim.fn.filereadable(file_path) == 1 then
      vim.notify(collection_name:gsub("^%l", string.upper) .. " '" .. filename .. "' already exists", vim.log.levels.WARN)
      return
    end

    -- Create file with h1 header
    local h1_title = input:gsub("^%s+", ""):gsub("%s+$", "") -- Trim the original input
    local content = { "# " .. h1_title, "" }
    vim.fn.writefile(content, file_path)

    -- Open the newly created file
    vim.cmd("edit " .. vim.fn.fnameescape(file_path))
    vim.notify("Created " .. collection_name:sub(1, -2) .. ": " .. filename, vim.log.levels.INFO)

    -- Regenerate index if the collection has one
    if config.has_index then
      local index_module = require(config.index_module)
      index_module.regenerate_index()
    end
  end)
end

return M
