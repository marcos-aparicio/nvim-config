local function with_case_settings(callback)
  local gi, gs = vim.go.ignorecase, vim.go.smartcase
  vim.go.ignorecase = true
  vim.go.smartcase = false
  local ok, result = pcall(callback)
  vim.go.ignorecase = gi
  vim.go.smartcase = gs
  if not ok then
    error(result)
  end
  return result
end

return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    modes = {
      search = {
        enabled = true,
      },
      char = {
        jump_labels = true
      }
    }
  },
  -- stylua: ignore
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        with_case_settings(function()
          require("flash").jump()
        end)
      end,
      desc = "Flash"
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        with_case_settings(function()
          require("flash").treesitter()
        end)
      end,
      desc = "Flash Treesitter"
    },
    {
      "r",
      mode = "o",
      function()
        with_case_settings(function()
          require("flash").remote()
        end)
      end,
      desc = "Remote Flash"
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        with_case_settings(function()
          require("flash").treesitter_search()
        end)
      end,
      desc = "Treesitter Search"
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search"
    },
  },
}
