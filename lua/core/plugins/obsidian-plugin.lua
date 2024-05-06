local OBSIDIAN_PATH = vim.fn.expand("~") .. "/Vaults/**/**.md"

vim.keymap.set("n", "<leader>ow", ":ObsidianWorkspace<CR>", { noremap = true })
vim.opt.conceallevel = 2

return {
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
			-- Toggle check-boxes.
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			["<leader>ot"] = { action = ":ObsidianTags<CR>" },
			["<leader>ll"] = { action = ":ObsidianSearch<CR>" },
			["<leader>os"] = { action = ":ObsidianSearch<CR>" },
			["<leader>or"] = { action = ":ObsidianRename<CR>" },
			["<leader>on"] = { action = ":ObsidianNew<CR>" },
			-- Smart action depending on context, either follow link or toggle checkbox.
			["<CR>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},
		workspaces = {
			{
				name = "zettelkasten",
				path = "~/Vaults/zettelkasten",
			},
			{
				name = "personal reference",
				path = "~/Vaults/personal_reference",
			},
			{
				name = "informatics reference",
				path = "~/Vaults/informatics_reference",
			},
		},
	},
}
