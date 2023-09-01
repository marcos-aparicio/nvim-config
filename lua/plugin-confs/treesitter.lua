-- this file also includes all treesitter extensions
local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

local rainbow_ok, rb = pcall(require, "ts-rainbow")
local rainbow_config = {}
if rainbow_ok then
	rainbow_config = {
		-- disable = { "" }, --languages that won't include it
		-- Use parentheses by default, entire tags for HTML and blocks for LaTeX
		enable = true,
		query = {
			"rainbow-parens",
			html = "rainbow-tags",
			latex = "rainbow-blocks",
		},
		strategy = { rb.strategy["global"] },
	}
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
	rainbow = rainbow_config,
})
