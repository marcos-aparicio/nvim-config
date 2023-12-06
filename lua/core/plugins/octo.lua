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
		{ "<leader>opl", ":Octo pr list<CR>" },
		{ "<leader>ope", ":Octo pr edit<space>" },
		{ "<leader>opr", ":Octo pr reload<CR>" },
		{ "<leader>or", ":Octo review<space>" },
		{ "<leader>oc", ":Octo comment<space>" },
		{ "<leader>ois", ":Octo issue list" },
		{ "<leader>oic", ":Octo issue create<CR>" },
		{ "<leader>os", OctoSearchLocalRepo, expr = true },
	},
	cmd = { "Octo" },
	config = function()
		require("octo").setup()
	end,
}
