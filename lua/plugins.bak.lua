local packer_path = os.getenv("HOME") .. "/.config/nvim/pack"

local ensure_packer = function()
	local fn = vim.fn
	local install_path = packer_path .. "/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

local packer = require("packer")
packer.init({ package_root = packer_path, opt = false })
packer.reset()

packer.startup(function(use)
	use("wbthomason/packer.nvim")
	-- use("tpope/vim-abolish")
	-- use("tpope/vim-surround")
	-- use("tpope/vim-speeddating")
	-- use("tpope/vim-fugitive")
	-- use("ayu-theme/ayu-vim")
	-- use({
	-- 	"Fymyte/rasi.vim",
	-- 	ft = "rasi",
	-- })
	-- use("christoomey/vim-tmux-navigator")
	-- use("ianding1/leetcode.vim")
	-- use("easymotion/vim-easymotion")
	-- use("akinsho/bufferline.nvim")
	-- use("moll/vim-bbye")
	-- use({
	--  --  "ziontee113/color-picker.nvim",
	--  -- })
	-- use("tpope/vim-dispatch")
	-- use({ "vimwiki/vimwiki", branch = "dev" })
	-- use("andrewradev/linediff.vim")
	-- use("sindrets/diffview.nvim")
	-- use("norcalli/nvim-colorizer.lua")
	-- use({ "lewis6991/gitsigns.nvim", branch = "release" })
	-- use({
	-- 	"windwp/nvim-autopairs",
	-- 	config = function()
	-- 		require("nvim-autopairs").setup()
	-- 	end,
	-- })
	-- Markdown Live Preview
	-- use({
	-- 	"iamcco/markdown-preview.nvim",
	-- 	run = function()
	-- 		vim.fn["mkdp#util#install"]()
	-- 	end,
	-- })
	-- use({
	-- 	"ggandor/leap.nvim",
	-- 	config = function()
	-- 		require("leap").add_default_mappings()
	-- 	end,
	-- 	requires = {
	-- 		"tpope/vim-repeat",
	-- 	},
	-- })
	-- Chat GPT like a pro
	-- use({
	-- 	"jackMort/ChatGPT.nvim",
	-- 	config = function() end,
	-- 	requires = {
	-- 		"MunifTanjim/nui.nvim",
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- })
	-- use("natecraddock/workspaces.nvim")
	-- use("MattesGroeger/vim-bookmarks")

	-- este lo tendras en su propio archivo
	use({ "akinsho/toggleterm.nvim", tag = "*" })

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
	})

	-- folding like VSC
	use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })

	use("numToStr/Comment.nvim") -- Easily comment stuff

	use("windwp/nvim-ts-autotag")
	use("JoosepAlviste/nvim-ts-context-commentstring") -- for comment context

	use("ThePrimeagen/git-worktree.nvim")

	-- LSP like a pro
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	})

	-- Completion
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	--esto lo tendras en otro archivo relacionado a cmp
	use("kristijanhusak/vim-dadbod-completion")
	use("saadparwaiz1/cmp_luasnip")

	-- Snippets
	use("L3MON4D3/LuaSnip") --Snippet Engine
	use("rafamadriz/friendly-snippets")
	use("hrsh7th/cmp-nvim-lsp")

	-- Formatting related plugins
	use("jose-elias-alvarez/null-ls.nvim")
	use("MunifTanjim/prettier.nvim")

	-- Debugging
	use("mfussenegger/nvim-dap")
	use("mfussenegger/nvim-dap-python")
	use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
	use("theHamsta/nvim-dap-virtual-text")

	-- dadbod (database client inside NEOVIM), esto lo tendras en otro archivo tambien
	use({
		"kristijanhusak/vim-dadbod-ui",
		requires = {
			"tpope/vim-dadbod",
			"tpope/vim-dotenv",
		},
	})

	-- nvim-tree and dependencies
	use({
		"nvim-tree/nvim-tree.lua",
		requires = { { "nvim-tree/nvim-web-devicons" } },
	})

	-- nvim-tresitter and extension plugins
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	use("HiPhish/rainbow-delimiters.nvim")

	-- Telescope and extensions
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.4",
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use("ElPiloto/telescope-vimwiki.nvim")
	use("nvim-telescope/telescope-live-grep-args.nvim")
	use("tom-anders/telescope-vim-bookmarks.nvim")

	-- tenerlo desactivado
	use("ThePrimeagen/harpoon")

	--propio archivo too
	use({
		"pwntester/octo.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
	})

	-- Typescript and Javascript support in LSP tsserver
	use({
		"pmizio/typescript-tools.nvim",
		requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("typescript-tools").setup({
				filetypes = {
					"javascript",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
			})
		end,
	})

	-- Automatically set up your configuration after cloning packer.nvim
	if packer_bootstrap then
		packer.sync()
	end
	packer.compile()
end)
