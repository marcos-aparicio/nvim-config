function OctoSearchLocalRepo()
  local remote_repos = vim.fn.systemlist("git remote get-url origin")
  local github_repo_index = 0
  for i, repo in pairs(remote_repos) do
    if string.find(repo, "github") then
      github_repo_index = i
      break
    end
  end
  if github_repo_index == 0 then
    print("It doesn't make sense to use octo if this repo doesn't have a github remote repo")
    return
  end

  local remote_url = remote_repos[github_repo_index]
  if not string.find(remote_url, "github") then
    print("It doesn't make sense to use octo if this repo doesn't have a github remote repo")
    return
  end

  local extracted_repo = string.match(remote_url, "git@github%.com:(.*)%.git")

  -- Insert the desired command
  return ":Octo search repo:" .. extracted_repo .. "<space>"
end

return {
  "pwntester/octo.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>opl", ":Octo pr list<CR>", desc = "List PRs" },
    { "<leader>ope", ":Octo pr edit<space>", desc = "Edit PR" },
    { "<leader>opr", ":Octo pr reload<CR>", desc = "Reload PR" },
    { "<leader>opc", ":Octo pr create<CR>", desc = "Create PR" },
    { "<leader>or", ":Octo review<space>", desc = "Review PR" },
    { "<leader>oc", ":Octo comment<space>", desc = "Comment on PR/Issue" },
    { "<leader>ois", ":Octo issue list", desc = "List Issues" },
    { "<leader>oic", ":Octo issue create<CR>", desc = "Create Issue" },
    { "<leader>os", OctoSearchLocalRepo, expr = true, desc = "Search in local repo" },
  },
  cmd = { "Octo" },
  main = "octo",
  opts = {
    suppress_missing_scope = {
      project_v2 = true,
    },
  },
}
