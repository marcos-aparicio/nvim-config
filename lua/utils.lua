local utils = {}
function utils.prequire(module_name)
	local ok, module = pcall(require, module_name)
	if not ok then
		return false
	end
	return module
end

return utils
