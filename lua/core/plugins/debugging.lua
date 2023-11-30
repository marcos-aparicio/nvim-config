local M = require("mappings")
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")

require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
require("dap-python").test_runner = "pytest"
require("dapui").setup({})
require("nvim-dap-virtual-text").setup({})
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
M.nmap("<leader>dt", function()
	local filetype = vim.bo.filetype
	local types_debuggers = {
		python = "dap-python",
	}
	print("filetype: " .. filetype)
	local ok, debugger = pcall(require, types_debuggers[filetype])
	if not ok then
		print("No DAP clients for this filetype")
		return
	end
	debugger.test_method()
end)
M.nmap("<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>")
M.nmap("<leader>dc", ":lua require'dap'.continue()<CR>")
