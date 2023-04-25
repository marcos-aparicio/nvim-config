local status_ok, formatter = pcall(require, "formatter")
if not status_ok then
	return
end
formatter.setup({
	filetype = {
		lua = { require("formatter.filetypes.lua").stylua },
	},
})
