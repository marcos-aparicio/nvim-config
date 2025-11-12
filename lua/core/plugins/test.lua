return {
  {
    "nvim-neotest/neotest",
    ft = { "python", "py", "typescript", "ts", "javascript", "js" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "marilari88/neotest-vitest",
      "nvim-neotest/nvim-nio",
    },
    opts = function()
      local neotest = require("neotest")
      local map = vim.keymap.set
      map("n", "<leader>tr", function()
        neotest.run.run()
      end)
      map("n", "<leader>tt", function()
        neotest.run.run(vim.fn.expand("%"))
      end)
      map("n", "<leader>ts", function()
        neotest.summary.toggle()
      end)
      map("n", "<leader>to", function()
        neotest.output.open({ enter = true, auto_close = true })
      end)
      map("n", "<leader>tO", function()
        neotest.output_panel.toggle()
      end)
      map("n", "<leader>tw", function()
        neotest.watch.toggle(vim.fn.expand("%"))
      end)

      return {
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
              return file_path:match("%.test%.js$") or
                  file_path:match("%.test%.ts$") or
                  file_path:match("%.test%.jsx$") or
                  file_path:match("%.test%.tsx$")
            end,
          })
        },
      }
    end,
  },
}
