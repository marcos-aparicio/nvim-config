vim.keymap.set({ "n" }, "<leader>al", ":AerialToggle left<CR>")

vim.keymap.set({ "n" }, "<leader>at", function()
  require("aerial").snacks_picker({
    on_close = function()
      -- After picker closes (user selected something), unfold if in markdown
      vim.defer_fn(function()
        if vim.bo.filetype ~= "markdown" then
          return
        end

        local line = vim.fn.line(".")
        -- Keep unfolding until the line is visible
        for _ = 1, 30 do
          if vim.fn.foldclosed(line) == -1 then
            break
          end
          vim.cmd("normal! zo")
        end
        -- Center the screen on the cursor line
        vim.cmd("normal! zz")
      end, 10)
    end,
  })
end, { desc = "Toggle Aerial Snack picker with all symbols" })

return {
  "stevearc/aerial.nvim",
  -- The two <leader>a* maps above are plain keymaps set at startup; they route
  -- through :AerialToggle / require("aerial"), both of which load the plugin.
  cmd = {
    "AerialToggle", "AerialOpen", "AerialOpenAll", "AerialClose", "AerialCloseAll",
    "AerialNext", "AerialPrev", "AerialGo", "AerialInfo",
    "AerialNavToggle", "AerialNavOpen", "AerialNavClose",
  },
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
