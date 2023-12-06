local M = require("mappings")

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
	vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
	vim.keymap.set("n", "<C-N>", function()
		vim.api.nvim_command("wincmd p")
	end, opts("Toggle w/ file"))
	vim.keymap.set("n", "O", api.tree.change_root_to_node, opts("Change root to node"))
end

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
	update_cwd = true,
	on_attach = my_on_attach,
    }

M.nmap("<C-n>", ":NvimTreeFindFile<CR>")
M.nmap("<C-b>", ":NvimTreeToggle<CR>")
  end,
}
