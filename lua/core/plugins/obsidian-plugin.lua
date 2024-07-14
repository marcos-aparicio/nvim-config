local OBSIDIAN_PATH = vim.fn.expand("~") .. "/Vaults/**/**.md"
local OBSIDIAN_LIST_PATH = vim.fn.expand("~") .. "/Vaults/**/*lists.md"

vim.keymap.set("n", "<leader>ow", ":ObsidianWorkspace<CR>", { noremap = true })
vim.opt.conceallevel = 2
-- TODO: haz mas fina esta webada
local work_subvault = "/home/marcos/Vaults/zettelkasten/Operations/Work"

local function createNoteWithDefaultTemplate()
	local ZETTEL_TEMPLATE_FILENAME = "note-taking.md"
	local obsidian = require("obsidian").get_client()
	local utils = require("obsidian.util")

	-- prevent Obsidian.nvim from injecting it's own frontmatter table
	obsidian.opts.disable_frontmatter = true

	-- prompt for note title
	-- @see: borrowed from obsidian.command.new

	local current_directory = vim.fn.getcwd()
	local note
	local title = utils.input("Enter title or path (optional): ")

	if not title then
		return
	elseif title == "" then
		title = nil
	end

	local template_used = ZETTEL_TEMPLATE_FILENAME
	if title ~= nil then
		local possible_folder = title:find("/")
		if possible_folder and title:sub(0, possible_folder - 1) ~= "Zettels" then
			template_used = "default.md"
		end
	end
	if current_directory == work_subvault then
		title = "Operations/Work/" .. title
	end

	note = obsidian:create_note({ title = title, no_write = true })

	if not note then
		return
	end
	-- open new note in a buffer
	obsidian:open_note(note, { sync = true })
	-- NOTE: make sure the template folder is configured in Obsidian.nvim opts
	obsidian:write_note_to_buffer(note, { template = template_used })
	-- hack: delete empty lines before frontmatter; template seems to be injected at line 2
	vim.api.nvim_buf_set_lines(0, 0, 1, false, {})
	obsidian.opts.disable_frontmatter = false
end

return {
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			"BufReadPre " .. OBSIDIAN_PATH,
			"BufNewFile " .. OBSIDIAN_PATH,
		},
		cmd = { "ObsidianWorkspace" },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			mappings = {
				["<leader>ot"] = { action = ":ObsidianTags<CR>" },
				["<leader>op"] = { action = ":ObsidianTemplate<CR>" },
				["<leader>tt"] = { action = ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>" },
				["<leader>ll"] = { action = ":ObsidianSearch<CR>" },
				["<leader>os"] = { action = ":ObsidianSearch<CR>" },
				["<leader>ol"] = { action = ":ObsidianLinks<CR>" },
				["<leader>ob"] = { action = ":ObsidianBacklinks<CR>" },
				["<leader>om"] = { action = ":ObsidianTags MOC<CR>" },
				["<leader>oo"] = { action = ":ObsidianOpen<CR>" },
				--- From Obsidian Insert or Obsidian paste Img
				["<leader>oi"] = { action = ":ObsidianPasteImg<CR>" },
				["<leader>or"] = { action = ":ObsidianRename<CR>" },
				["<leader>on"] = { action = createNoteWithDefaultTemplate, desc = "[N]ew Obsidian [N]ote" },
				-- Smart action depending on context, either follow link or toggle checkbox.
				["<CR>"] = {
					action = function()
						-- local bufnr = vim.api.nvim_get_current_buf()
						--
						-- local success, val = pcall(vim.api.nvim_buf_get_var, bufnr, "is_task")
						-- if success then
						-- 	return vim.cmd("TWToggle")
						-- end
						return require("obsidian").util.smart_action()
					end,
					opts = { buffer = true, expr = true },
				},
			},

			workspaces = {
				{
					name = "zettelkasten",
					path = "~/Vaults/zettelkasten",
					overrides = {
						notes_subdir = "Zettels",
						new_notes_location = "Zettels",
						templates = {
							folder = "Templates",
							date_format = "%Y-%m-%d",
							time_format = "%H:%M",
						},
					},
				},
				-- Might not use those
				{
					name = "personal reference",
					path = "~/Vaults/personal_reference",
				},
				{
					name = "informatics reference",
					path = "~/Vaults/informatics_reference",
				},
			},
			-- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
			-- URL it will be ignored but you can customize this behavior here.
			---@param url string
			follow_url_func = function(url)
				-- Open the URL in the default web browser.
				vim.fn.jobstart({ "xdg-open", url }) -- linux
			end,
		},
	},
	-- additional plugin for taskwarrior management from nvim
	{
		"huantrinh1802/m_taskwarrior_d.nvim",
		version = "*",
		dependencies = { "MunifTanjim/nui.nvim" },
		event = {
			"BufReadPre " .. OBSIDIAN_LIST_PATH,
			"BufNewFile " .. OBSIDIAN_LIST_PATH,
		},
		config = function()
			-- Require
			require("m_taskwarrior_d").setup()

			vim.api.nvim_create_autocmd({ "BufEnter", "BufReadPre", "BufNewFile" }, {
				group = vim.api.nvim_create_augroup("TWTaskBindings", { clear = true }),
				pattern = OBSIDIAN_LIST_PATH,
				callback = function()
					local bufnr = vim.api.nvim_get_current_buf()
					vim.api.nvim_buf_set_var(bufnr, "is_task", 1)

					vim.api.nvim_buf_set_keymap(
						bufnr,
						"n",
						"<leader>te",
						"<cmd>TWEditTask<cr>",
						{ desc = "TaskWarrior Edit", noremap = true, silent = true }
					)
					vim.api.nvim_buf_set_keymap(
						bufnr,
						"n",
						"<leader>tv",
						"<cmd>TWView<cr>",
						{ noremap = true, silent = true }
					)
					vim.api.nvim_buf_set_keymap(
						bufnr,
						"n",
						"<leader>tq",
						"<cmd>TWQueryTasks<cr>",
						{ noremap = true, silent = true }
					)
					vim.api.nvim_buf_set_keymap(
						bufnr,
						"n",
						"<leader>tu",
						"<cmd>TWUpdateCurrent<cr>",
						{ noremap = true, silent = true }
					)

					vim.api.nvim_buf_set_keymap(
						bufnr,
						"n",
						"<leader>ts",
						"<cmd>TWSyncTasks<cr>",
						{ noremap = true, silent = true }
					)
					vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ch", "<cmd>TWToggle<cr>", { silent = true })
					-- vim.keymap.set("n", "<CR>", ":TWToggle<CR>", { noremap = true, silent = true, buffer = bufnr })
				end,
			})
			-- Be caution: it may be slow to open large files, because it scan the whole buffer
			-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			-- 	group = vim.api.nvim_create_augroup("TWTask", { clear = true }),
			-- 	pattern = OBSIDIAN_LIST_PATH, -- Pattern to match Markdown files
			-- 	callback = function()
			-- 		vim.cmd("TWSyncTasks")
			-- 	end,
			-- })
		end,
	},
}
