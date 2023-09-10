-- this file also includes all treesitter extensions
local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

-- checking if it actually loaded
treesitter.setup({
	ensure_installed = "all",
	sync_install = false,
	ignore_install = { "" }, --languages you dont want the maintained version
	autotag = { enable = true },
	highlight = {
		enable = true,
		disable = { "typescriptreact" }, --don't highlight this languages
		additional_vim_regex_highlighting = true,
	},
	indent = { enable = true, disable = { "yaml" } },
})
