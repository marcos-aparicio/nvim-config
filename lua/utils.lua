local utils = {}
function utils.prequire(module_name)
	local ok, module = pcall(require, module_name)
	if not ok then
		return false
	end
	return module
end

function utils.tablemerge(table1, table2)
	local output = {}

	for _, v in ipairs(table1) do
		table.insert(output, v)
	end
	for _, v in ipairs(table2) do
		table.insert(output, v)
	end
	return output
end

return utils
