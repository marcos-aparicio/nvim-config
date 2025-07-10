return {
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    cmd = "Telescope live_grep_args",
  },
  { "jvgrootveld/telescope-zoxide", cmd = "Telescope zoxide" },
  {
    'polarmutex/git-worktree.nvim',
    version = '^2',
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    }
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    event = "VeryLazy",
    -- tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")
      local action_state = require("telescope.actions.state")
      local builtin = require("telescope.builtin")
      local lga_actions = require("telescope-live-grep-args.actions")

      local keymaps = {
        { "n", "<leader>f",   builtin.find_files },
        { "n", "<leader>b",   builtin.buffers },
        { "n", "<leader>gfl", builtin.git_bcommits },
        { "n", "<leader>gt",  ":Telescope git_worktree<CR>" },
        { "n", "<leader>td",  ":Telescope diagnostics<CR>" },
        { "v", "<leader>ll",  "y<ESC>:Telescope live_grep_args default_text=<c-r>0<CR>" },
        { "n", "<leader>z",   telescope.extensions.zoxide.list },
        { "n", "<leader>gs",  builtin.git_status },
        { "n", "<leader>gb",  builtin.git_branches },
        { "n", "<leader>tp",  ":Telescope projects<CR>" },
        { "n", "<leader>th",  builtin.help_tags },
        { "n", "<leader>/",   builtin.current_buffer_fuzzy_find },
        {
          "n",
          "<leader>ll",
          function()
            telescope.extensions.live_grep_args.live_grep_args({
              auto_quoting = true, -- enable/disable auto-quoting
              mappings = {
                i = {
                  ["<C-k>"] = lga_actions.quote_prompt(),
                  ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                  -- freeze the current list and start a fuzzy search in the frozen list
                  ["<C-space>"] = lga_actions.to_fuzzy_refine,
                },
              },
            })
          end,
        },
        {
          "n",
          "<leader>rf",
          function()
            builtin.find_files({
              no_ignore = true,
              find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
            })
          end,
        },
      }

      for _, map in ipairs(keymaps) do
        local opts = { noremap = true, silent = true }
        -- Merge opts with map[4], if it exists
        local final_opts = map[4] and vim.tbl_extend("force", opts, map[4]) or opts
        vim.keymap.set(map[1], map[2], map[3], final_opts)
      end

      telescope.load_extension("live_grep_args")
      telescope.load_extension("projects")
      telescope.load_extension('git_worktree')

      -- telescope.load_extension("bookmarks")
      -- telescope.load_extension("zoxide")
      return {
        defaults = {
          preview = {
            -- source: https://github.com/nvim-telescope/telescope.nvim/issues/623#issuecomment-921978316
            filesize_hook = function(filepath, bufnr, opts)
              local max_bytes = 10000
              local cmd = { "head", "-c", max_bytes, filepath }
              require("telescope.previewers.utils").job_maker(cmd, bufnr, opts)
            end,
          },
          theme = "ivy",
          layout_config = {
            width = 0.9,
            preview_width = 0.6,
            height = 0.9,
            prompt_position = "top",
          },

          wrap_results = true,
          mappings = {
            i = {
              ["<C-c>"] = actions.close,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-p>"] = action_layout.toggle_preview,
            },
            n = {
              ["q"] = actions.close,
              ["<C-p>"] = action_layout.toggle_preview,
            },
          },
        },
        pickers = {
          marks = {
            layout_strategy = "horizontal",
            layout_config = {
              width = 0.9,
              preview_width = 0.3,
            },
          },
          find_files = {
            file_ignore_patterns = { "node_modules" },
          },
          git_bcommits = {
            mappings = {
              n = {
                yy = function()
                  local entry = action_state.get_selected_entry()
                  vim.fn.setreg("+", entry.value)
                  print(entry.value .. " was copied to the clipboard")
                end,
              },
            },
          },
          git_branches = {
            mappings = {
              n = {
                yy = function()
                  local entry = action_state.get_selected_entry()
                  vim.fn.setreg("+", entry.value)
                  print(entry.value .. " was copied to the clipboard")
                end,
                ff = function(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  local selected_branch = entry.value
                  local remote_repos = vim.fn.systemlist("git remote show")
                  local processed_branch = selected_branch
                  for _, remote_repo in pairs(remote_repos) do
                    if string.find(selected_branch, "^" .. remote_repo .. "/") then
                      processed_branch =
                          string.gsub(selected_branch, "^" .. remote_repo .. "/", "")
                      break
                    end
                  end

                  if processed_branch == selected_branch then
                    print("This branch is not remote!")
                    return
                  end

                  actions.close(prompt_bufnr)
                  vim.fn.system("git checkout " .. processed_branch)
                  print("git checkout to " .. processed_branch)
                end,
                rr = function(prompt_bufnr)
                  local entry = action_state.get_selected_entry()
                  local selected_branch = entry.value
                  -- checkout out to a random branch
                  actions.close(prompt_bufnr)
                  vim.fn.system("git checkout $(git branch -- list | shuf -n 1 | sed '/^\\* //')")
                  vim.api.nvim_feedkeys(":G branch -m " .. selected_branch .. " ", "n", true)
                  print("Branch: " .. selected_branch .. " was renamed")
                end,
              },
            },
          },
          current_buffer_fuzzy_find = {
            previewer = false,
          },
        },
        extensions = {
          bookmarks = {
            list = {
              theme = "ivy",
              layout_config = {
                width = 0.8,
              },
            },
          },
        },
      }
    end,
  },
}
