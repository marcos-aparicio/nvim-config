-- Resolve the branch a PR would target, preferring the remote's default HEAD.
local function resolve_base()
  local head = vim.fn.systemlist({ "git", "symbolic-ref", "--short", "refs/remotes/origin/HEAD" })[1]
  if vim.v.shell_error == 0 and head and head ~= "" then
    return head
  end
  for _, candidate in ipairs({ "origin/main", "origin/master", "main", "master" }) do
    vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", candidate })
    if vim.v.shell_error == 0 then
      return candidate
    end
  end
end

return {
  "dlyongemallo/diffview.nvim",
  lazy = false,
  keys = {
    { "<leader>gd", ":DiffviewFileHistory %" },
    { "<leader>gD", ":DiffviewOpen --current-file" },
    { "<leader>ge", ":DiffviewOpen<CR>" },
    { "<leader>gp", ":DiffviewPR<CR>", desc = "Diffview: PR-style diff vs base branch" },
  },
  init = function()
    -- :DiffviewPR [base] -- review the current branch like a GitHub PR: only the
    -- commits unique to HEAD, diffed against the merge-base with the base branch.
    vim.api.nvim_create_user_command("DiffviewPR", function(opts)
      local base = opts.args ~= "" and opts.args or resolve_base()
      if not base then
        vim.notify("DiffviewPR: could not resolve a base branch", vim.log.levels.ERROR)
        return
      end
      vim.cmd("DiffviewOpen " .. base .. "...HEAD --imply-local")
    end, {
      nargs = "?",
      desc = "Diffview: diff current branch against its base branch (PR view)",
      complete = function(arg)
        local branches = vim.fn.systemlist({ "git", "branch", "--all", "--format=%(refname:short)" })
        return vim.tbl_filter(function(b)
          return vim.startswith(b, arg)
        end, branches)
      end,
    })
  end,
}
