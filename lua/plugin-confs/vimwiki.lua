local wikis = require("plugin-confs.vimwiki-private")

local vimwiki_paths_object = {}
for _, wiki in ipairs(wikis) do
  local vimwiki_path_object = {
    path = wiki.path,
    syntax = "markdown",
    ext = ".md",
    auto_generate_links = 1,
  }
  table.insert(vimwiki_paths_object, vimwiki_path_object)
end

vim.api.nvim_set_var("vimwiki_list", vimwiki_paths_object)
vim.g.wiki_auto_header = 1

vim.cmd([[
  augroup vimwiki_mappings
    autocmd!
    autocmd FileType vimwiki lua set_vimwiki_mappings()
  augroup END
]])

-- setting general keybinding to iterate through vimwikis

function set_vimwiki_mappings()
  local buffer = vim.api.nvim_get_current_buf()
  local buffer_path = vim.api.nvim_buf_get_name(buffer)

  for _, wiki in ipairs(wikis) do
    if buffer_path:match(wiki.path) then
      vim.api.nvim_buf_set_keymap(
        buffer,
        "n",
        "<Leader>f",
        ':lua require"telescope.builtin".find_files({ cwd = "'
        .. wiki.path
        .. '", prompt_title = "vimwiki", previewer = false })<cr>',
        { noremap = true }
      )
      vim.api.nvim_buf_set_keymap(
        buffer,
        "n",
        "<Leader>l",
        ":Telescope vimwiki live_grep<CR>",
        { noremap = true }
      )
      vim.api.nvim_buf_set_keymap(
        buffer,
        "n",
        "<Leader>x",
        ":w ~/.local/share/Trash/files/%:t<Bar>:VimwikiDeleteFile<CR>y<CR>",
        { noremap = true }
      )
    end
  end
end

local ok, telescope = pcall(require, "telescope")
if not ok then
  return
end

local wikis_for_telescope = {}
for _, wiki in ipairs(wikis) do
  table.insert(wikis_for_telescope, wiki.name)
end

-- Create the Telescope picker
function iterateVimWikis()
  local actions = require("telescope.actions")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local sorters = require("telescope.sorters")
  local state = require("telescope.actions.state")

  -- Create a Telescope picker
  local picker = pickers.new({}, {
    prompt_title = "Vimwiki Wikis",
    finder = finders.new_table({
      results = wikis_for_telescope,
    }),
    sorter = sorters.get_generic_fuzzy_sorter(),
    attach_mappings = function(prompt_bufnr, map)
      local select_item = function()
        local selection = state.get_selected_entry()

        local vimwiki_index = 1
        for idx, wiki in ipairs(wikis) do
          if wiki.name == selection.value then
            vimwiki_index = idx
            break
          end
        end

        actions.close(prompt_bufnr)
        if selection then
          vim.cmd("VimwikiIndex " .. vimwiki_index)
        end
      end

      -- Map <CR> to select_item function
      map("i", "<CR>", select_item)
      map("n", "<CR>", select_item)

      return true
    end,
  })

  -- Open the Telescope picker
  picker:find()
end

vim.api.nvim_set_keymap("n", "<leader>r", ":lua iterateVimWikis()<CR>", { noremap = true, silent = true })
