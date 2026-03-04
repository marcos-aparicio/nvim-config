return {
  "dlyongemallo/diffview.nvim",
  lazy = false,
  keys = {
    { "<leader>gd", ":DiffviewFileHistory %" },
    { "<leader>gD", ":DiffviewOpen --current-file" },
    { "<leader>ge", ":DiffviewOpen<CR>" },
  },
}
