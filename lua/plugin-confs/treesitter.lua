local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

local ok_status, rainbow = pcall(require, "ts-rainbow")
if not ok_status then
	return
end

treesitter.setup({
	ensure_installed = "all",
	sync_install = false,
	ignore_install = { "" }, --languages you dont want the maintained version
	highlight = {
		enable = true,
		disable = { "" }, --don't highlight this languages
		additional_vim_regex_highlighting = true,
	},
	indent = { enable = true, disable = { "yaml" } },
	rainbow = {
		enable = true,
		disable = {}, --languages that won't include it
		query = "rainbow-parens",
		strategy = rainbow.strategy.global,
	},
})
