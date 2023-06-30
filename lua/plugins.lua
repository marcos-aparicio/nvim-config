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

packer = require("packer")
packer.init({ package_root = packer_path, opt = false })
packer.reset()

packer.startup(function(use)
	use("wbthomason/packer.nvim")
	use("tpope/vim-abolish")

	use("tpope/vim-surround")
	use("tpope/vim-fugitive")
	use("vim-airline/vim-airline")
	use("vim-airline/vim-airline-themes")
	use("ayu-theme/ayu-vim")
	use({
		"Fymyte/rasi.vim",
		ft = "rasi",
	})
	--[[ use("mg979/vim-visual-multi") ]]
	-- rest api testing(like Postman!)
	use("rest-nvim/rest.nvim")

	-- folding like VSC
	use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })

	use("numToStr/Comment.nvim") -- Easily comment stuff

	use("akinsho/bufferline.nvim")
	use("moll/vim-bbye")

	use("vimwiki/vimwiki")

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup()
		end,
	})
	use("windwp/nvim-ts-autotag")
	use("JoosepAlviste/nvim-ts-context-commentstring") -- for comment context

	use("easymotion/vim-easymotion")
	use("theniceboy/vim-calc")
	use("lewis6991/gitsigns.nvim")
	use("norcalli/nvim-colorizer.lua")

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

	use({ "akinsho/toggleterm.nvim", tag = "*" })

	-- dadbod (database client inside NEOVIM)
	use({
		"kristijanhusak/vim-dadbod-ui",
		requires = {
			"tpope/vim-dadbod",
			"tpope/vim-dotenv",
		},
	})

	-- using jira inside vim
	use("n0v1c3/vira")
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
	use({ "HiPhish/nvim-ts-rainbow2", after = "nvim-treesitter" })

	-- Telescope and extensions
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	use("nvim-telescope/telescope-project.nvim")
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})

	use("ElPiloto/telescope-vimwiki.nvim")
	use("cljoly/telescope-repo.nvim")

	use("natecraddock/workspaces.nvim")

	use({
		"AckslD/nvim-neoclip.lua",
		config = function()
			require("telescope").load_extension("neoclip")
			require("neoclip").setup()
		end,
	})
	use("chentoast/marks.nvim")

	use({
		"pwntester/octo.nvim",
		--[[ requires = { ]]
		--[[ 	"nvim-lua/plenary.nvim", ]]
		--[[ 	"nvim-telescope/telescope.nvim", ]]
		--[[ 	"nvim-tree/nvim-web-devicons", ]]
		--[[ }, ]]
	})

	use("tpope/vim-dispatch")

	-- Automatically set up your configuration after cloning packer.nvim
	if packer_bootstrap then
		packer.sync()
	end
	packer.compile()
end)
