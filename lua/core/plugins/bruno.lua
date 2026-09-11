return {
  "romek-codes/bruno.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Pickers
    -- Choose one based on whichever picker you prefer.
    "nvim-telescope/telescope.nvim",
  },
  -- Dragging telescope + plenary in at startup for an HTTP client that is only
  -- ever reached through :Bruno* was the single biggest dependency cascade here.
  cmd = { "BrunoRun", "BrunoEnv", "BrunoSearch", "BrunoToggleFormat" },
  opts = {
    -- Paths to your bruno collections.
    collection_paths = {
      { name = "Main", path = "~/Projects/bruno/Main/" },
    },
    -- Which picker to use, "fzf-lua" or "snacks" are also allowed.
    picker = "telescope",
    -- If output should be formatted by default.
    show_formatted_output = true,
    -- If formatting fails for whatever reason, don't show error message (will always fallback to unformatted output).
    suppress_formatting_errors = false

  }
}
