local ok, null_ls = pcall(require, "null-ls")
if not ok then
	return
end
local formatting = null_ls.builtins.formatting

local sources = {
	formatting.stylua.with({
		extra_args = function(params)
			local buffer_path = vim.fn.expand("%:p")
			local new_params = {}

			-- proof that based on the buffer path certain formatting can be applied
			-- if buffer_path == "/home/marcos/.config/awesome/rc.lua" then
			-- 	table.insert(new_params, "--quote-style")
			-- 	table.insert(new_params, "AutoPreferSingle")
			-- end
			return params.options and new_params
		end,
	}),
	formatting.prettierd.with({
		extra_filetypes = { "xhtml" },
	}),
	formatting.black,
	formatting.sql_formatter,
	formatting.beautysh,
	formatting.phpcsfixer,
}
return sources
