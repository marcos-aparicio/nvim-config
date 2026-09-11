return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
  -- Nothing registers mcphub as a codecompanion extension, so :MCPHub is the
  -- only entry point; spawning the hub at startup was pure cost.
  cmd = { "MCPHub" },
  config = function()
    require("mcphub").setup()
  end,
}
