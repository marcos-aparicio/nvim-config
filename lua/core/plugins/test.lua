-- Every neotest entry point is a <leader>t* mapping, so `keys` is the trigger:
-- the mappings exist from startup, but neotest and its four adapters (plus
-- nvim-nio, FixCursorHold and jit.p) only load the first time one is pressed.
local function run(fn)
  return function()
    fn(require("neotest"))
  end
end

return {
  {
    "nvim-neotest/neotest",
    cmd = { "Neotest" },
    ft = { "python", "typescript", "javascript", "go" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "marilari88/neotest-vitest",
      "nvim-neotest/nvim-nio",
      {
        "fredrikaverpil/neotest-golang",
        version = "*", -- Optional, but recommended; track releases
        build = function()
          vim.system({ "go", "install", "gotest.tools/gotestsum@latest" }):wait() -- Optional, but recommended
        end,
      },
    },
    keys = {
      { "<leader>tr", run(function(n) n.run.run() end), desc = "Neotest: run nearest" },
      { "<leader>tt", run(function(n) n.run.run(vim.fn.expand("%")) end), desc = "Neotest: run file" },
      { "<leader>ts", run(function(n) n.summary.toggle() end), desc = "Neotest: toggle summary" },
      { "<leader>to", run(function(n) n.output.open({ enter = true, auto_close = true }) end), desc = "Neotest: output" },
      { "<leader>tO", run(function(n) n.output_panel.toggle() end), desc = "Neotest: output panel" },
      { "<leader>tw", run(function(n) n.watch.toggle(vim.fn.expand("%")) end), desc = "Neotest: watch file" },
    },
    opts = function()
      return {
        level = vim.log.levels.DEBUG,
        adapters = {
          require("neotest-python")({
            dap = { justMyCode = false },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
          }),
          require("neotest-vitest")({
            ---Custom criteria for a file path to determine if it is a vitest test file.
            ---@async
            ---@param file_path string Path of the potential vitest test file
            ---@return boolean
            is_test_file = function(file_path)
              return file_path:match("%.test%.js$")
                or file_path:match("%.test%.ts$")
                or file_path:match("%.test%.jsx$")
                or file_path:match("%.test%.tsx$")
            end,
          }),
          require("neotest-golang"),
        },
      }
    end,
  },
}
