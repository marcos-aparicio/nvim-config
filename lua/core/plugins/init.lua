-- require("plugin-confs.telescope")
-- require("plugin-confs.toggleterm")
-- require("plugin-confs.gitsigns")
-- require("plugin-confs.treesitter")
-- require("plugin-confs.colorizer")
-- require("plugin-confs.prettier")
-- require("plugin-confs.completions")
-- require("plugin-confs.luasnip")
-- require("plugin-confs.lualine")
-- require("plugin-confs.vim-bookmarks")
-- require("plugin-confs.chatgpt-nvim")
-- require("plugin-confs.octo-nvim")
-- require("plugin-confs.color-picker")
-- require("plugin-confs.lsp")
-- require("plugin-confs.dbui")
-- require("plugin-confs.bufferline")
-- require("plugin-confs.harpoon")
-- require("plugin-confs.comments")
-- require("plugin-confs.workspaces")
-- require("plugin-confs.leetcode")
-- require("plugin-confs.vimwiki")
-- require("plugin-confs.vira")
-- require("plugin-confs.taskwiki")
-- require("plugin-confs.debugging")
-- require("plugin-confs.nvim-tree")

return {
	"tpope/vim-abolish",
	"tpope/vim-surround",
	"tpope/vim-speeddating",
	"tpope/vim-fugitive",
	{
		"ayu-theme/ayu-vim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.ayucolor = "dark"
			vim.cmd([[
  colorscheme ayu
  hi Normal guibg=NONE ctermbg=NONE
  ]])
		end,
	},
	"tpope/vim-dispatch",
	-- "Treesitter for rasi filetype"
	{
		"Fymyte/rasi.vim",
		ft = "rasi",
	},
	"christoomey/vim-tmux-navigator",
	"ianding1/leetcode.vim",
	"easymotion/vim-easymotion",
	"ziontee113/color-picker.nvim",
	"windwp/nvim-autopairs",
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons", "moll/vim-bbye" },
	},
	{ "vimwiki/vimwiki", branch = "dev" },
	{
		"andrewradev/linediff.vim",
		cmd = {
			"Linediff",
			"LinediffAdd",
			"LinediffLast",
			"LinediffMerge",
			"LinediffPick",
			"LinediffReset",
			"LinediffShow",
		},
	},
	{
		"sindrets/diffview.nvim",
		cmd = {
			{
				"Diffview",
				"DiffviewClose",
				"DiffviewFileHistory",
				"DiffviewFocusFiles",
				"DiffviewLog",
				"DiffviewOpen",
				"DiffviewRefresh",
				"DiffviewToggleFiles",
			},
		},
	},
	"norcalli/nvim-colorizer.lua",
	{
		"lewis6991/gitsigns.nvim",
		branch = "release",
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown", "vimwiki" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()
		end,
		dependencies = {
			"tpope/vim-repeat",
		},
	},
	"MattesGroeger/vim-bookmarks",
	{
		"jackMort/ChatGPT.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
	"natecraddock/workspaces.nvim",
	"ThePrimeagen/harpoon",
}
