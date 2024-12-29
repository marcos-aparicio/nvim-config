return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"saadparwaiz1/cmp_luasnip",
		},
		opts = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local default_sources = {
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "lazydev", group_index = 0 },
			}
			local has_words_before = function()
				if not pcall(vim.api.nvim_win_get_cursor, 0) then
					return false
				end
				local line, col = table.unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			return {

				mapping = {
					-- basic completion mappings
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-g>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
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
						luasnip.lsp_expand(args.body)
					end,
				},

				sources = cmp.config.sources(default_sources),
				experimental = { ghost_text = false },

				formatting = {
					fields = { "kind", "abbr", "menu" }, --the order of the items
					format = function(entry, vim_item)
						vim_item.kind = ""
						vim_item.menu = ({
							lazydev = "[LazyDev]",
							luasnip = "[Snippet]",
							BladeNav = "[BladeNav]",
							nvim_lsp = "[LSP]",
							buffer = "[Buffer]",
							path = "[Path]",
						})[entry.source.name]
						-- return require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
						-- TODO: add this colorizer
						return vim_item
					end,
				},
			}
		end,
		-- config = function()
		-- 	require("core.plugins.completions.setup")
		-- end,
		--
		-- TODO: fix this completion source
		-- for _, language in ipairs({ "sql", "mysql", "plsql" }) do
		-- 	cmp.setup.filetype(language, {
		-- 		sources = cmp.config.sources({
		-- 			table.unpack(default_sources),
		-- 			{
		-- 				name = "vim-dadbod-completion",
		-- 			},
		-- 		}),
		-- 	})
		-- end
	},
}
