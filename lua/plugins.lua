-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]
packer = require("packer")
packer.init({ package_root = "~/.config/nvim/pack", opt = false })
local use = packer.use
packer.reset()

return packer.startup(function()
	use("tpope/vim-abolish")
	use("tpope/vim-commentary")
	use("tpope/vim-surround")
	use("tpope/vim-fugitive")
	use("wbthomason/packer.nvim")
	use("vim-airline/vim-airline")
	use("vim-airline/vim-airline-themes")
	use("ayu-theme/ayu-vim")
	use("jiangmiao/auto-pairs")
	use("easymotion/vim-easymotion")
	use("theniceboy/vim-calc")
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.1",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = require("plugin-confs.telescope"),
	})
	use({
		"mhartington/formatter.nvim",
		config = require("plugin-confs.formatter-nvim"),
	})
	use({
		"nvim-tree/nvim-tree.lua",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = require("plugin-confs.nvim-tree"),
	})
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
		config = require("plugin-confs.toggleterm"),
	})

	-- nvim-tresitter and aditional plugins
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = require("plugin-confs.treesitter"),
	})
	use({ "HiPhish/nvim-ts-rainbow2" })
end)
