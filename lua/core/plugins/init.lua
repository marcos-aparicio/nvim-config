return {
	"tpope/vim-abolish",
	"tpope/vim-obsession",
	"ThePrimeagen/harpoon",
	"tpope/vim-surround",
	"easymotion/vim-easymotion",
	"tpope/vim-speeddating",
	"tpope/vim-dispatch",
	-- "Treesitter for rasi filetype"
	{ "Fymyte/rasi.vim", ft = "rasi" },
	{ "christoomey/vim-tmux-navigator", opts = {} },
	{ "andrewradev/linediff.vim", cmd = "Linediff" },
	{ "norcalli/nvim-colorizer.lua", main = "colorizer" },
	{ "lewis6991/gitsigns.nvim", tag = "v0.6", lazy = false, opts = {} },
	{ "Pocco81/HighStr.nvim", main = "high-str", opts = {} },
	{
		"Shatur/neovim-ayu",
		lazy = false,
		priority = 1000,
		main = "ayu",
		opts = {
			mirage = false,
			overrides = {
				Normal = { bg = "None" },
				ColorColumn = { bg = "None" },
				SignColumn = { bg = "None" },
				Folded = { bg = "None" },
				FoldColumn = { bg = "None" },
				CursorLine = { bg = "None" },
				CursorColumn = { bg = "None" },
				WhichKeyFloat = { bg = "None" },
				LineNr = { fg = "#FFD580" },
				LineNrAbove = { fg = "#606366" },
				LineNrBelow = { fg = "#606366" },
				VertSplit = { bg = "None" },
			},
		},
		init = function()
			require("ayu").colorscheme()
		end,
	},
	{
		"ziontee113/color-picker.nvim",
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
		config = function()
			require("leap").add_default_mappings()
		end,
		dependencies = {
			"tpope/vim-repeat",
		},
	},
	{
		"github/copilot.vim",
		config = function()
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
		tag = "v2.2.1",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"tpope/vim-dotenv",
			"MunifTanjim/nui.nvim",
		},
		cmd = { "Sail", "Artisan", "Composer", "Npm", "Yarn", "Laravel" },
		keys = {
			{ "<leader>la", ":Laravel artisan<cr>" },
			{ "<leader>lr", ":Laravel routes<cr>" },
			{ "<leader>lm", ":Laravel related<cr>" },
			{
				"<leader>lt",
				function()
					require("laravel.tinker").send_to_tinker()
				end,
				mode = "v",
				desc = "Laravel Application Routes",
			},
		},
		event = { "VeryLazy" },
		config = function()
			require("laravel").setup()
			require("telescope").load_extension("laravel")
		end,
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
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
}
