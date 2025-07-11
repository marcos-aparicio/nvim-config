return {
  "jackMort/ChatGPT.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = {
    api_key_cmd = "pass show personal/api_keys/openai",
    openai_params = {
      model = "gpt-4o-mini"
    },
  },
  keys = {
    { "<leader>aie", ":ChatGPTEditWithInstructions<CR>", mode = { "v", "n" } },
    { "<leader>aiq", ":ChatGPT<CR>" },
    { "<leader>air", ":ChatGPTRun<space>",               mode = { "v", "n" } },
    { "<leader>aid", ":ChatGPTRun docstring<CR>",        mode = "v" },
    { "<leader>ait", ":ChatGPTRun add_tests<CR>",        mode = "v" },
  },
}
