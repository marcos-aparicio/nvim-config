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

return packer.startup(function(use)
	use("wbthomason/packer.nvim")
	use("tpope/vim-abolish")
	use("tpope/vim-commentary")
	use("tpope/vim-surround")
	use("tpope/vim-fugitive")
	use("vim-airline/vim-airline")
	use("vim-airline/vim-airline-themes")
	use("ayu-theme/ayu-vim")
	use("jiangmiao/auto-pairs")
	use("easymotion/vim-easymotion")
	use("theniceboy/vim-calc")
	use("mhartington/formatter.nvim")

	--toggleterm
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
	})

	-- nvim-tree and dependencies
	use({
		"nvim-tree/nvim-tree.lua",
		requires = { { "nvim-tree/nvim-web-devicons" } },
	})

	-- nvim-tresitter and aditional plugins
	use({
		"nvim-treesitter/nvim-treesitter",
		requires = { "HiPhish/nvim-ts-rainbow2" },
		run = ":TSUpdate",
	})
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Automatically set up your configuration after cloning packer.nvim
	if packer_bootstrap then
		packer.sync()
	end
end)
