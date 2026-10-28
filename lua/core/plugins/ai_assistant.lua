return {
  {
    "folke/sidekick.nvim",
    opts = function()
      -- Agents run as plain Neovim terminals that live and die with this
      -- Neovim. Sidekick also scans tmux for agents started elsewhere and
      -- offers them as send targets; `is_proc = false` turns that off so these
      -- sessions stay separate from the agents in other tmux windows.
      local tools = {
        omp = { cmd = { "omp" } },
        omp_resume = { cmd = { "omp", "--resume" } },
      }
      for _, file in ipairs(vim.api.nvim_get_runtime_file("sk/cli/*.lua", true)) do
        tools[vim.fn.fnamemodify(file, ":t:r")] = {}
      end
      for _, tool in pairs(tools) do
        tool.is_proc = false
      end

      return {
        -- Next Edit Suggestions need the Copilot LSP; only the CLI side is used.
        nes = { enabled = false },
        cli = {
          win = {
            layout = "right",
            split = { width = 0 }, -- 0 = half the screen
          },
          tools = tools,
        },
      }
    end,

    keys = {
      {
        "<leader>ac",
        function() require("sidekick.cli").toggle({ name = "omp", focus = true }) end,
        mode = { "n", "v" },
        desc = "Toggle omp",
      },
      {
        "<leader>an",
        function() require("sidekick.cli").select() end,
        desc = "Pick or start an agent session",
      },
      {
        "<leader>ar",
        function() require("sidekick.cli").toggle({ name = "omp_resume", focus = true }) end,
        desc = "Resume an omp session",
      },
      {
        "<leader>aC",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = "x",
        desc = "Send selection to agent",
      },
      {
        "<leader>aC",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        mode = "n",
        desc = "Send file to agent",
      },
      -- capitalized to avoid the buffer-local <leader>ad Anki mapping in telescope.lua
      {
        "<leader>aD",
        function() require("sidekick.cli").send({ prompt = "diagnostics" }) end,
        mode = "n",
        desc = "Send buffer diagnostics to agent",
      },
      {
        "<C-a>",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick prompt palette",
      },
    },
  },
}
