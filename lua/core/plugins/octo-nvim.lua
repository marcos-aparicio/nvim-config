local M = require("mappings")
local ok, octo = pcall(require, "octo")
if not ok then
	return
end

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

octo.setup()
M.nmap("<leader>opl", ":Octo pr list<CR>")
M.nmap("<leader>ope", ":Octo pr edit<space>")
M.nmap("<leader>opr", ":Octo pr reload<CR>")
M.nmap("<leader>or", ":Octo review<space>")
M.nmap("<leader>oc", ":Octo comment<space>")
M.nmap("<leader>ois", ":Octo issue list")
M.nmap("<leader>oic", ":Octo issue create<CR>")
M.nmap("<leader>os", OctoSearchLocalRepo, { expr = true })
M.nmap("<leader>oo", OctoSearchLocalRepo)
