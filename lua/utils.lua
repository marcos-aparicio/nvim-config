local utils = {}
function utils.prequire(module_name)
	local ok, module = pcall(require, module_name)
	if not ok then
		return false
	end
	return module
end

--- Get the content of the current identifier node. requires nvim-treesitter
-- @param structure_node_name The name of the structure node to search for (e.g., "method_declaration").
-- @param identifier_node_name The name of the identifier node to search for within the structure node (e.g., "name").
-- @return The content of the identifier node as a string, or an empty string if not found.
-- @throws Error if the nvim-treesitter.ts_utils dependency is not found.
function utils.get_current_identifier_node_content(structure_node_name, identifier_node_name)
	local status, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
	if not status then
		error("nvim-treesitter.ts_utils not found")
	end
	local current_node = ts_utils.get_node_at_cursor()
	while current_node and current_node:type() ~= structure_node_name do
		current_node = current_node:parent()
	end

	if not current_node then
		return ""
	end

	local function find_id_node(node)
		if node:type() == identifier_node_name then
			return vim.treesitter.get_node_text(node, 0)
		end
		for i = 0, node:named_child_count() - 1 do
			local name = find_id_node(node:named_child(i))
			if name then
				return name
			end
		end
		return nil
	end

	return find_id_node(current_node) or ""
end

return utils
