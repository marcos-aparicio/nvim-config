function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return {
			desc = "nvim-tree: " .. desc,
			buffer = bufnr,
			noremap = true,
			silent = true,
			nowait = true,
		}
	end

	api.config.mappings.default_on_attach(bufnr)

	-- your removals and mappings go here
	vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
	vim.keymap.set("v", "l", api.node.open.edit, opts("Open"))
	vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
	vim.keymap.set("n", "<C-N>", function()
		vim.api.nvim_command("wincmd p")
	end, opts("Toggle w/ file"))
	vim.keymap.set("n", "O", api.tree.change_root_to_node, opts("Change root to node"))
end

return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	cmd = { "NvimTreeFindFile", "NvimTreeToggle" },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	main = "nvim-tree",
	opts = {
		update_cwd = true,
		on_attach = my_on_attach,
	},
	init = function()
		vim.keymap.set("n", "<C-n>", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<C-b>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
	end,
}
