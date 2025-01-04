return {
	"tpope/vim-abolish",
	"tpope/vim-obsession",
	"kkoomen/vim-doge",
	"tpope/vim-surround",
	"easymotion/vim-easymotion",
	"tpope/vim-speeddating",
	"tpope/vim-dispatch",
	-- "Treesitter for rasi filetype"
	{ "Fymyte/rasi.vim", ft = "rasi" },
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},
	{ "andrewradev/linediff.vim", cmd = "Linediff" },
	{ "norcalli/nvim-colorizer.lua", main = "colorizer" },
	{
		"lewis6991/gitsigns.nvim",
		tag = "v0.6",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {},
	},
	{ "Pocco81/HighStr.nvim", main = "high-str", opts = {} },
	{
		"ziontee113/color-picker.nvim",
		cmd = { "PickColor", "PickColorInsert" },
		keys = {
			{ "<leader>co", "<Cmd>PickColor<CR>", mode = { "n" } },
			{ "<C-c>", "<Cmd>PickColorInsert<CR>", mode = { "i" } },
		},
		main = "color-picker",
		opts = {},
	},
	{ "windwp/nvim-autopairs", main = "nvim-autopairs", opts = {} },
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons", "moll/vim-bbye" },
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		keys = {
			{ "<C-p>", "<Cmd>MarkdownPreview<CR>", ft = { "markdown", "vimwiki" } },
			{ ",ll", "<Cmd>MarkdownPreview<CR>", ft = { "markdown", "vimwiki" } },
		},
		ft = { "markdown", "vimwiki" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{
		"ggandor/leap.nvim",
		main = "leap",
		event = "VeryLazy",
		opts = function()
			require("leap").add_default_mappings()
			return {}
		end,
		dependencies = { "tpope/vim-repeat" },
	},
	{
		"github/copilot.vim",
		event = "VeryLazy",
		init = function()
			vim.g.copilot_filetypes =
				{ markdown = false, vimwiki = false, xml = false, html = false, json = false, toggleterm = false }
			vim.cmd([[highlight CopilotSuggestion guifg=#555555 ctermfg=8]])
			vim.keymap.set("i", "<C-;>", 'copilot#Accept("<CR>")', {
				expr = true,
				replace_keycodes = false,
			})
			vim.g.copilot_no_tab_map = true
		end,
	},
	{
		"adalessa/laravel.nvim",
		dependencies = {
			"tpope/vim-dotenv",
			"nvim-telescope/telescope.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-treesitter/nvim-treesitter",
			"kevinhwang91/promise-async",
		},
		cmd = { "Laravel" },
		keys = {
			{ "<leader>la", ":Laravel artisan<cr>" },
			{ "<leader>lr", ":Laravel routes<cr>" },
			{ "<leader>lm", ":Laravel related<cr>" },
		},
		event = { "VeryLazy" },
		opts = {},
		config = true,
	},
	{
		"chrisgrieser/nvim-rip-substitute",
		keys = {
			{
				"<leader>rs",
				function()
					require("rip-substitute").sub()
				end,
				mode = { "n", "x" },
				desc = " rip substitute",
			},
		},
	},
}
