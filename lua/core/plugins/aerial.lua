vim.keymap.set({ "n" }, "<leader>al", ":AerialToggle left<CR>")
vim.keymap.set({ "n" }, "<leader>at", function()
  vim.b.aerial_filter_kind = nil
  require("aerial").snacks_picker()
end, { desc = "Toggle Aerial Snack picker with all symbols" })
vim.keymap.set({ "n" }, "<leader>av", function()
  vim.b.aerial_filter_kind = { "Variable", "Constant", "Field", "Property" }
  require("aerial").snacks_picker()
  vim.b.aerial_filter_kind = nil
end, { desc = "Toggle Aerial Snack picker with only variables" })

vim.keymap.set({ "n" }, "<leader>af", function()
  vim.b.aerial_filter_kind = { "Function", "Method" }
  require("aerial").snacks_picker()
  vim.b.aerial_filter_kind = nil
end, { desc = "Toggle Aerial Snack picker with only functions" })

return {
  "stevearc/aerial.nvim",
  opts = {
    attach_mode = "global",
    backends = { "lsp", "treesitter", "markdown", "man" },
    show_guides = true,
    layout = {
      resize_to_content = false,
      win_opts = {
        winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
        signcolumn = "yes",
        statuscolumn = " ",
      },
    },
    filter_kind = false,
    guides = {
      mid_item = "├╴",
      last_item = "└╴",
      nested_top = "│ ",
      whitespace = "  ",
    },
  },
  -- Optional dependencies
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
}
