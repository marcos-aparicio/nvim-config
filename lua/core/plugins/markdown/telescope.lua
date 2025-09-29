local M = {}

local function get_h1_from_file(filename)
  -- Get buffer number, create if doesn't exist
  local bufnr = vim.fn.bufnr(filename)
  if bufnr == -1 then
    -- Buffer doesn't exist, create and load it
    bufnr = vim.fn.bufadd(filename)
    vim.fn.bufload(bufnr)
  elseif not vim.api.nvim_buf_is_loaded(bufnr) then
    -- Buffer exists but isn't loaded
    vim.fn.bufload(bufnr)
  end

  -- -- Check Treesitter parser availability
  -- Ensure filetype is markdown
  if not vim.bo[bufnr] or vim.bo[bufnr].filetype ~= "markdown" then
    return ""
  end

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "markdown")
  if not ok or not parser then return "" end

  local query = vim.treesitter.query.parse("markdown", [[
    (atx_heading
      (atx_h1_marker)
      (inline) @h1_text)
  ]])
  local tree = parser:parse()[1]
  for _, node in query:iter_captures(tree:root(), bufnr, 0) do
    local text = vim.treesitter.get_node_text(node, bufnr)
    if text then
      return text
    end
  end
  return ""
end

local function filter_non_task_tags(tag)
  return not vim.startswith(tag, "_")
end

function M.get_tag_telescope_finder(tag, unique_by_filename)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local entry_display = require("telescope.pickers.entry_display")
  local themes = require("telescope.themes")

  -- Create custom picker for the selected tag
  vim.lsp.buf_request(0, "workspace/symbol", { query = "Tag: " .. tag }, function(err2, result2)
    if err2 or not result2 then
      print("No symbols found for tag: " .. tag)
      return
    end

    local displayer = entry_display.create({
      separator = " ",
      items = {
        { width = 50 }, -- filename
        { remaining = true }, -- line content
      },
    })

    local make_display = function(entry)
      local h1 = get_h1_from_file(entry.filename)

      return displayer({
        h1,
      })
    end

    local entries = {}
    local uniqueness_checker = {}
    for _, symbol in ipairs(result2) do
      if not symbol.location or not symbol.location.uri then
        goto continue
      end

      local uri = symbol.location.uri
      local filename = vim.uri_to_fname(uri)
      local range = symbol.location.range
      local lnum = range.start.line + 1
      local col = range.start.character + 1

      if not unique_by_filename or uniqueness_checker[filename] then
        goto continue
      end
      uniqueness_checker[filename] = true

      table.insert(entries, {
        filename = filename,
        lnum = lnum,
        col = col,
        text = symbol.name or "",
        display = make_display,
      })

      ::continue::
    end

    pickers.new(themes.get_ivy({
      prompt_title = tag,
      finder = finders.new_table({
        results = entries,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.display,
            ordinal = entry.filename .. " " .. (entry.text or ""),
            filename = entry.filename,
            lnum = entry.lnum,
            col = entry.col,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = conf.grep_previewer({}),
      layout_config = { preview_width = 0.5 },
      wrap_results = true,
    })):find()
  end)
end


local function pick_tag_and_search(tag_filter_fn, picker_title,unique_by_filename)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  vim.lsp.buf_request(0, "workspace/symbol", { query = "Tag:" }, function(err, result, ctx, config)
    if err or not result then
      print("No tags found")
      return
    end

    local tags = {}
    for _, symbol in ipairs(result) do
      if not symbol.name then
        goto continue
      end
      local tag = symbol.name:match("Tag:%s*(.+)")
      if not tag or (tag_filter_fn and not tag_filter_fn(tag)) then
        goto continue
      end
      tags[tag] = true
      ::continue::
    end

    local tag_list = vim.tbl_keys(tags)
    if #tag_list == 0 then
      print("No tags found")
      return
    end

    pickers.new({}, {
      prompt_title = picker_title and picker_title or "Select Tag",
      finder = finders.new_table({ results = tag_list }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if not selection then
            return
          end

          M.get_tag_telescope_finder(selection[1],unique_by_filename)

        end)
        return true
      end,
    }):find()
  end)
end

function M.search_tasks_with_tag(tag)
  if not tag or tag == "" then return end
  local pattern = string.format("^\\s*- \\[[ -]\\].*%s", vim.pesc(tag))
  require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
    prompt_title = "Tasks with tag: " .. tag,
    search = pattern,
    search_dirs = { vim.fn.getcwd() },
    use_regex = true,
    initial_mode = "normal",
    layout_config = { preview_width = 0.5 },
    wrap_results = true,
    additional_args = function() return { "--no-ignore" } end,
  }))
end

function M.pick_tag_and_search()
  pick_tag_and_search(filter_non_task_tags, "Filter Tags", true)
end

function M.pick_task_tag_and_search()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  vim.lsp.buf_request(0, "workspace/symbol", { query = "Tag:" }, function(err, result)
    if err or not result then
      print("No tags found")
      return
    end

    local tags = {}
    for _, symbol in ipairs(result) do
      if symbol.name then
        local tag = symbol.name:match("Tag:%s*(.+)")
        if tag and vim.startswith(tag, "_") then
          tags[tag] = true
        end
      end
    end

    local tag_list = vim.tbl_keys(tags)
    if #tag_list == 0 then
      print("No task tags found")
      return
    end

    pickers.new({}, {
      prompt_title = "Select Task Tag",
      finder = finders.new_table({ results = tag_list }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if not selection then return end
          local tag = selection[1]
          M.search_tasks_with_tag(tag)
        end)
        return true
      end,
    }):find()
  end)
end

function M.search_completed_tasks()
  require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
    prompt_title = "Completed Tasks",
    search = "^\\s*- \\[x\\]",
    search_dirs = { vim.fn.getcwd() },
    use_regex = true,
    initial_mode = "normal",
    layout_config = { preview_width = 0.5 },
    wrap_results = true,
    additional_args = function() return { "--no-ignore" } end,
  }))
end

function M.search_progress_tasks()
  require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
    prompt_title = "Tasks In Progress 🕐",
    search = "^\\s*- \\[-\\]",
    search_dirs = { vim.fn.getcwd() },
    use_regex = true,
    initial_mode = "normal",
    layout_config = { preview_width = 0.5 },
    wrap_results = true,
    additional_args = function() return { "--no-ignore" } end,
  }))
end

function M.search_incomplete_tasks()
  require("telescope.builtin").grep_string(require("telescope.themes").get_ivy({
    prompt_title = "Incomplete Tasks",
    search = "^\\s*- \\[ \\]",
    search_dirs = { vim.fn.getcwd() },
    use_regex = true,
    initial_mode = "normal",
    layout_config = { preview_width = 0.5 },
    additional_args = function() return { "--no-ignore" } end,
  }))
end

return M
