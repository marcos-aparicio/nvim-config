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
        normal = "?"
      },
      reset = {
        insert = "",
        normal = "grs"
      }
    }
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
			},
		},
	}
end
