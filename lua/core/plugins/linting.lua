return {
  "mfussenegger/nvim-lint",
  cmd = "Lint",
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      -- javascriptreact = { "eslint_d" },
      -- typescript = { "eslint_d" },
      -- typescriptreact = { "eslint_d" },
      php = { "phpcs" },
      scss = { "stylelint" },
      zsh = { "shellcheck" },
      sh = { "shellcheck" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    --
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
