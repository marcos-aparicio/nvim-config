local leet_arg = "leetcode.nvim"

return {
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim", -- required by telescope
      "MunifTanjim/nui.nvim",

      -- optional
      "nvim-treesitter/nvim-treesitter",
      -- "rcarriga/nvim-notify",
      "nvim-tree/nvim-web-devicons",
    },
    -- lazy = leet_arg ~= vim.fn.argv()[1],
    cmd = { "Leet" },
    opts = {
      -- configuration goes here
      arg = leet_arg,
      lang = "python",
      hooks = {
        ["enter"] = {
          function()
            vim.keymap.set(
              "n",
              "<leader>ls",
              "<cmd>Leet submit<cr>",
              { noremap = true, silent = true }
            )
            vim.keymap.set(
              "n",
              "<leader>lt",
              "<cmd>Leet test<cr>",
              { noremap = true, silent = true }
            )
            vim.keymap.set(
              "n",
              "<leader>ld",
              "<cmd>Leet desc<cr>",
              { noremap = true, silent = true }
            )
          end,
        },
      },
    },
  },
}
