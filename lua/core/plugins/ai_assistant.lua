local USE_CODECOMPANION = false -- Set to false to use CopilotChat

local codecompanion_config = {
  "olimorris/codecompanion.nvim",
  opts = {
    -- extensions = {
    --   vectorcode = {
    --     opts = {
    --       tool_group = {
    --         enabled = true,
    --         extras = {},
    --         collapse = false,
    --       },
    --       tool_opts = {
    --         ["*"] = {},
    --         ls = {},
    --         vectorise = {},
    --         query = {
    --           max_num = { chunk = -1, document = -1 },
    --           default_num = { chunk = 50, document = 10 },
    --           include_stderr = false,
    --           use_lsp = false,
    --           no_duplicate = true,
    --           chunk_mode = false,
    --           summarise = {
    --             enabled = false,
    --             adapter = nil,
    --             query_augmented = true,
    --           },
    --         },
    --         files_ls = {},
    --         files_rm = {},
    --       },
    --     },
    --   },
    -- },
  },
  keys = {
    { "<leader>at", ":CodeCompanionChat toggle<CR>" },
    { "<leader>aa", ":CodeCompanionActions <CR>" },
    { "<leader>ap", ":CodeCompanion " },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
}

local copilotchat_config = {
  "copilotc-nvim/copilotchat.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim", branch = "master" },
  },
  keys = { { "<leader>ac", ":CopilotChatToggle<cr>" } },
  build = "make tiktoken",
  opts = {
    mappings = {
      show_help = {
        normal = "?",
      },
      reset = {
        insert = "",
        normal = "grs",
      },
    },
  },
}

if USE_CODECOMPANION then
  return { codecompanion_config }
else
  return {
    {
      "copilotc-nvim/copilotchat.nvim",
      dependencies = {
        { "nvim-lua/plenary.nvim", branch = "master" },
      },
      cmd = { "CopilotChatToggle", "CopilotChat" },
      keys = {
        { "<leader>ac", ":CopilotChatToggle<cr>" },
        { "<leader>a.", ":CopilotChatSave ", mode = "n", ft = "copilot-chat" },
        {
          "<leader>a,",
          ":CopilotChatLoad ",
          ft = "copilot-chat",
          { desc = "Open CopilotChat History Picker" },
        },
      },
      build = "make tiktoken",
      opts = {
        mappings = {
          show_help = {
            normal = "?",
          },
          reset = {
            normal = "grs",
          },
        },
        functions = {
          dir_tree = {
            description = "Returns a tree view of the given directory path",
            uri = "tree://{path}",
            schema = {
              type = "object",
              required = { "path" },
              properties = {
                path = {
                  type = "string",
                  description = "Directory path to display as a tree",
                },
              },
            },
            resolve = function(input)
              local max_level = 4 -- set your desired depth
              local handle = io.popen("tree -L " .. max_level .. ' "' .. input.path .. '"')
              local result = ""
              if handle then
                result = handle:read("*a")
                handle:close()
              else
                result = "Error: Unable to open directory or run 'tree' command."
              end
              return {
                {
                  uri = "tree://" .. input.path,
                  mimetype = "text/plain",
                  data = result,
                },
              }
            end,
          },
        },
      },
    },
  }
end
