return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },

    ---@type CodeCompanion.Config
    opts = {
      adapters = {
        acp = {
          -- Hide every other ACP preset; only Claude Code and OpenCode are
          -- offered as providers.
          opts = { show_presets = false },
          claude_code = function() return require("codecompanion.adapters").extend("claude_code") end,
          opencode = function() return require("codecompanion.adapters").extend("opencode") end,
        },
      },
      interactions = {
        chat = {
          -- Default provider. Switch per-session with `ga` in the chat buffer,
          -- or `:CodeCompanionChat adapter=claude_code|opencode`.
          adapter = "opencode",
        },
      },
    },

    keys = {
      -- was <leader>ac (Toggle Agentic Chat)
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = { "n", "v" },
        desc = "Toggle CodeCompanion Chat",
      },
      -- was <leader>an (New Agentic Session)
      {
        "<leader>an",
        function() require("codecompanion").chat() end,
        mode = { "n", "v" },
        desc = "New CodeCompanion Chat",
      },
      -- was <leader>aC (Add File or Selection to Agentic Context)
      {
        "<leader>aC",
        "<cmd>CodeCompanionChat Add<cr>",
        mode = "v",
        desc = "Add Selection to CodeCompanion Chat",
      },
      -- was <leader>ad / <leader>aD (Add Diagnostics to Agentic); capitalized
      -- to avoid the existing buffer-local <leader>ad Anki mapping in telescope.lua
      {
        "<leader>aD",
        function() vim.cmd([[CodeCompanionChat #{diagnostics} Can you help me fix these?]]) end,
        mode = "n",
        desc = "Send Buffer Diagnostics to CodeCompanion Chat",
      },
      -- Upstream's suggested workflow keymap for browsing all actions/prompts
      {
        "<C-a>",
        "<cmd>CodeCompanionActions<cr>",
        mode = { "n", "v" },
        desc = "CodeCompanion Action Palette",
      },
    },
  },
}
