local M = {}

local function filter_non_task_tags(tag)
  return not vim.startswith(tag, "_")
end

local function pick_tag_and_search(tag_filter_fn, picker_title)
  local telescope = require("telescope.builtin")
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
          telescope.lsp_workspace_symbols({
            query = "Tag: " .. selection[1],
            prompt_title = selection[1]
          })
        end)
        return true
      end,
    }):find()
  end)
end

function M.pick_tag_and_search()
  pick_tag_and_search(filter_non_task_tags)
end

function M.pick_task_tag_and_search()
  pick_tag_and_search(function(tag)
    return vim.startswith(tag, "_")
  end, "Select Task Tag:")
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
