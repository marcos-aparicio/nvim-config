return {
	"LintaoAmons/bookmarks.nvim",
	-- pin the plugin at specific version for stability
	-- backup your bookmark sqlite db when there are breaking changes
	-- tag = "v2.3.0",
	dependencies = {
		{ "kkharji/sqlite.lua" },
		{ "nvim-telescope/telescope.nvim" },
		{ "stevearc/dressing.nvim" }, -- optional: better UI
	},
	main = "bookmarks",
	keys = {
		{ "mm", ":BookmarksMark<CR>" },
		{ "mn", ":BookmarksGotoNext<CR>" },
		{ "ml", ":BookmarksLists<CR>" },
		{ "mp", ":BookmarksGotoPrev<CR>" },
		{ "ma", ":BookmarksGoto<CR>" },
		{ "mt", ":BookmarksTree<CR>" },
	},
	opts = function()
		local find_or_create_project_bookmark_group = function()
			local project_root = require("project_nvim.project").get_project_root()
			if not project_root then
				return
			end

      local project_name = string.gsub(project_root, "^" .. os.getenv("HOME") .. "/", "")
      local Service = require("bookmarks.domain.service")
      local Repo = require("bookmarks.domain.repo")
      local bookmark_list = nil

			for _, bl in ipairs(Repo.find_lists()) do
				if bl.name == project_name then
					bookmark_list = bl
					break
				end
			end

			if not bookmark_list then
				bookmark_list = Service.create_list(project_name)
			end
			Service.set_active_list(bookmark_list.id)
			require("bookmarks.sign").safe_refresh_signs()
		end
		vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
			group = vim.api.nvim_create_augroup("BookmarksGroup", {}),

			pattern = { "*" },
			callback = find_or_create_project_bookmark_group,
		})
		return {}
	end,
	event = { "BufReadPost", "BufWritePost", "BufNewFile" },
}
