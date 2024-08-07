return {
	"tpope/vim-abolish",
	"tpope/vim-obsession",
	"tpope/vim-surround",
	"tpope/vim-speeddating",
	"tpope/vim-dispatch",
	{
		"Pocco81/HighStr.nvim",
		config = function()
			require("high-str").setup()
		end,
	},
	{
		"Shatur/neovim-ayu",
		lazy = false,
		priority = 1000,
		config = function()
			require("ayu").setup({
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
					VertSplit = { bg = "None" },
				},
			})
			require("ayu").colorscheme()
		end,
	},
	-- "Treesitter for rasi filetype"
	{
		"Fymyte/rasi.vim",
		ft = "rasi",
	},
	{ "christoomey/vim-tmux-navigator", config = function() end },
	"easymotion/vim-easymotion",
	{
		"ziontee113/color-picker.nvim",
		keys = {
			{ "<leader>co", "<Cmd>PickColor<CR>", mode = { "n" } },
			{ "<C-c>", "<Cmd>PickColorInsert<CR>", mode = { "i" } },
		},
		config = function()
			require("color-picker").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons", "moll/vim-bbye" },
	},
	{
		"andrewradev/linediff.vim",
		cmd = "Linediff",
	},
	{
		"sindrets/diffview.nvim",
		cmd = "Diffview",
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		tag = "v0.6",
		lazy = false,
		config = function()
			require("gitsigns").setup()
		end,
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
	"ThePrimeagen/harpoon",
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
	"kkoomen/vim-doge",
	-- lazy.nvim
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>1",
				":Noice dismiss<CR>",
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			{
				"rcarriga/nvim-notify",
				config = function()
					require("notify").setup({
						background_colour = "#000000",
					})
				end,
			},
		},
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
