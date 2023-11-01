local ok, cmp = pcall(require, "cmp")

if not ok then
	return
end

local ok, luasnip = pcall(require, "luasnip")
if not ok then
	return
end

-- Helper Functions
local has_words_before = function()
	local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
--]]

require("luasnip.loaders.from_vscode").lazy_load()

local default_sources = {
	{ name = "luasnip" },
	{ name = "nvim_lsp" },
	{ name = "buffer" },
	{ name = "path" },
}

cmp.setup({
	mapping = {
		-- basic completion mappings
		["<C-j>"] = cmp.mapping.select_next_item(),
		["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-x>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		-- the TABS
		["<Tab>"] = cmp.mapping(function(fallback)
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif cmp.visible() then
				cmp.select_next_item()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			elseif cmp.visible() then
				cmp.select_prev_item()
			else
				fallback()
			end
		end, { "i", "s" }),
	},

	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},

	sources = cmp.config.sources(default_sources),

	formatting = {
		fields = { "kind", "abbr", "menu" }, --the order of the items
		format = function(entry, vim_item)
			vim_item.kind = ""
			vim_item.menu = ({
				luasnip = "[Snippet]",
				nvim_lsp = "[LSP]",
				buffer = "[Buffer]",
				path = "[Path]",
			})[entry.source.name]
			return vim_item
		end,
	},
})

for _, language in ipairs({ "sql", "mysql", "plsql" }) do
	cmp.setup.filetype(language, {
		sources = cmp.config.sources({
			table.unpack(default_sources),
			{
				name = "vim-dadbod-completion",
			},
		}),
	})
end
