return {
  {
    "carlos-algms/agentic.nvim",

    --- @type agentic.PartialUserConfig
    opts = {
      -- Any ACP-compatible provider works. Built-in: "claude-agent-acp" | "gemini-acp" | "codex-acp" | "opencode-acp" | "cursor-acp" | "copilot-acp" | "auggie-acp" | "mistral-vibe-acp" | "cline-acp" | "goose-acp" | "kiro-acp" | "pi-acp"
      provider = "opencode-acp",
    },

    keys = {
      -- was CopilotChatToggle
      {
        "<leader>ac",
        function() require("agentic").toggle() end,
        mode = { "n", "v" },
        desc = "Toggle Agentic Chat",
      },
      -- was CopilotChatLoad (history picker)
      {
        "<leader>a,",
        function() require("agentic").restore_session() end,
        mode = { "n", "v" },
        desc = "Agentic Restore Session",
      },
      -- no previous equivalent; kept in the same <leader>a* style
      {
        "<leader>an",
        function() require("agentic").new_session() end,
        mode = { "n", "v" },
        desc = "New Agentic Session",
      },
      {
        "<leader>aC",
        function() require("agentic").add_selection_or_file_to_context() end,
        mode = { "n", "v" },
        desc = "Add File or Selection to Agentic Context",
      },
      {
        "<leader>ad",
        function() require("agentic").add_current_line_diagnostics() end,
        mode = { "n" },
        desc = "Add Current Line Diagnostics to Agentic",
      },
      {
        "<leader>aD",
        function() require("agentic").add_buffer_diagnostics() end,
        mode = { "n" },
        desc = "Add Buffer Diagnostics to Agentic",
      },
      -- No public API for this; agentic.nvim only exposes open/close/toggle of the
      -- whole widget, not a focus swap, so we reach into the session's widget directly.
      {
        "<leader>af",
        function()
          require("agentic.session_registry").get_session_for_tab_page(nil, function(session)
            local widget = session.widget
            if not widget:is_open() then return end

            if widget:is_cursor_in_widget() then
              local target = widget:find_first_non_widget_window()
              if target then vim.api.nvim_set_current_win(target) end
            else
              local input_win = widget.win_nrs.input
              if input_win and vim.api.nvim_win_is_valid(input_win) then
                vim.api.nvim_set_current_win(input_win)
                vim.cmd("startinsert!")
              end
            end
          end)
        end,
        mode = { "n" },
        desc = "Toggle Focus Between Agentic Prompt and File Buffer",
      },
    },
  },
}
