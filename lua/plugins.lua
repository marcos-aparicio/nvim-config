local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

local packer = require("packer")
packer.init({ opt = false })
packer.reset()

packer.startup(function(use)
	use("wbthomason/packer.nvim")
	use("tpope/vim-abolish")

	use("tpope/vim-surround")
	use("tpope/vim-speeddating")
	use("tpope/vim-fugitive")
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
	})
	use("ayu-theme/ayu-vim")
	use({
		"Fymyte/rasi.vim",
		ft = "rasi",
	})

	-- folding like VSC
	use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })

	use("numToStr/Comment.nvim") -- Easily comment stuff

	use("akinsho/bufferline.nvim")
	use("moll/vim-bbye")

	use({ "vimwiki/vimwiki", branch = "dev" })

	use("andrewradev/linediff.vim")

	-- Tmux integration
	use("christoomey/vim-tmux-navigator")

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	})
	use("windwp/nvim-ts-autotag")
	use("JoosepAlviste/nvim-ts-context-commentstring") -- for comment context

	use("easymotion/vim-easymotion")
	use({
		"ggandor/leap.nvim",
		config = function()
			require("leap").add_default_mappings()
		end,
		requires = {
			"tpope/vim-repeat",
		},
	})
	use("sindrets/diffview.nvim")
	use("ThePrimeagen/git-worktree.nvim")
	use({ "lewis6991/gitsigns.nvim", branch = "release" })
	use("norcalli/nvim-colorizer.lua")

	-- coloorsss
	use({
		"ziontee113/color-picker.nvim",
	})

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

	-- Snippets
	use("L3MON4D3/LuaSnip") --Snippet Engine
	use("saadparwaiz1/cmp_luasnip")
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

	-- Markdown Live Preview
	use({
		"iamcco/markdown-preview.nvim",
		run = function()
			vim.fn["mkdp#util#install"]()
		end,
	})

	use({ "akinsho/toggleterm.nvim", tag = "*" })

	-- dadbod (database client inside NEOVIM)
	use({
		"kristijanhusak/vim-dadbod-ui",
		requires = {
			"tpope/vim-dadbod",
			"tpope/vim-dotenv",
		},
	})
	use("kristijanhusak/vim-dadbod-completion")

	-- using LeetCode inside Nvim(Awesome!)
	use("ianding1/leetcode.vim")

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

	use("natecraddock/workspaces.nvim")

	--[[ Marks, File Navigation ]]
	use("MattesGroeger/vim-bookmarks")
	use("tom-anders/telescope-vim-bookmarks.nvim")
	use("ThePrimeagen/harpoon")

	use({
		"pwntester/octo.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
	})

	-- Chat GPT like a pro
	use({
		"jackMort/ChatGPT.nvim",
		config = function() end,
		requires = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	})

	use("tpope/vim-dispatch")

	use({
		"folke/noice.nvim",
		event = "VimEnter",
		config = function()
			-- require("noice").setup({
			-- 	lsp = {
			-- 		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			-- 		override = {
			-- 			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			-- 			["vim.lsp.util.stylize_markdown"] = true,
			-- 			["cmp.entry.get_documentation"] = true,
			-- 		},
			-- 	},
			-- 	-- you can enable a preset for easier configuration
			-- 	presets = {
			-- 		bottom_search = true, -- use a classic bottom cmdline for search
			-- 		command_palette = true, -- position the cmdline and popupmenu together
			-- 		long_message_to_split = true, -- long messages will be sent to a split
			-- 		inc_rename = false, -- enables an input dialog for inc-rename.nvim
			-- 		lsp_doc_border = false, -- add a border to hover docs and signature help
			-- 	},
			-- 	messages = {
			-- 		enabled = false,
			-- 		-- view = "mini", -- default view for messages
			-- 		-- view_error = "cmdline", -- view for errors
			-- 		-- view_warn = "mini", -- view for warnings
			-- 		-- view_history = "mini", -- view for :messages
			-- 		-- view_search = "virtualtext",
			-- 	},
			-- })
		end,
		requires = {
			"MunifTanjim/nui.nvim",
			-- "rcarriga/nvim-notify",
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
