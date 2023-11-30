local ok, chatgpt = pcall(require, "chatgpt")
local M = require("mappings")
if not ok then
	return
end

chatgpt.setup({
	api_key_cmd = "pass show personal/api_keys/openai",
})
-- chatgpt nvim mappings
M.nmap("<leader>aiq", ":ChatGPT<CR>")
M.nmap("<leader>air", ":ChatGPT run<space>")
M.vmap("<leader>aid", ":ChatGPTRun docstring<CR>")
