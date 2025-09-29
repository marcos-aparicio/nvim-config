local list_patterns = {
  unordered = "[-+*]",
  digit = "%d+[.)]",
  ascii = "%a[.)]",
  roman = "%u*[.)]",
  latex_item = "\\item",
}

return {
  "gaoDean/autolist.nvim",
  ft = { "markdown", "text", "tex", "plaintex", "norg" },
  config = function()
    require("autolist").setup({
      lists = {
        markdown = {
          list_patterns.unordered,
          list_patterns.digit,
          list_patterns.ascii,
          list_patterns.roman,
          "[>*]",
        },
      },
    })

    local keymaps = require("core.plugins.markdown.keymaps")

    -- Autolist specific keymaps
    vim.keymap.set("i", "<tab>", "<cmd>AutolistTab<cr>")
    vim.keymap.set("i", "<s-tab>", "<cmd>AutolistShiftTab<cr>")
    vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
    vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
    vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
    vim.keymap.set("n", "<C-r>", "<cmd>AutolistRecalculate<cr>")

    -- Cycle list types with dot-repeat
    vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, { expr = true })

    -- Functions to recalculate list on edit
    vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
    vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
    vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
    vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")
  end,
}
