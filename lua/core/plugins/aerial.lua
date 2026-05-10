vim.keymap.set({ "n" }, "<leader>al", ":AerialToggle left<CR>")
vim.keymap.set({ "n" }, "<leader>at", function()
  require("aerial").snacks_picker()
end, { desc = "Toggle Aerial Snack picker with all symbols" })
vim.keymap.set({ "n" }, "<leader>av", function()
  -- Snacks.picker.lsp_symbols({ filter = { default = { "Variable", "Constant", "Field", "Property", "Object" } } })
  require('telescope.builtin').lsp_document_symbols({  symbols = { "variable", "constant", "field", "property", "object" }  })
end, { desc = "Toggle Aerial Snack picker with only variables" })

vim.keymap.set({ "n" }, "<leader>af", function()
  require('telescope.builtin').lsp_document_symbols({  symbols = {"function", "method"}  })
  -- require("aerial").snacks_picker({
  --   filter = { default = { "Function", "Method" } }
  -- })
  -- Snacks.picker.lsp_symbols({ filter = { default = { "Function", "Method" } } })
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
