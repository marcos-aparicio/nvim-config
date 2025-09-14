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

-- extracted from the GOAT: folke
-- this code is definitely not mine
-- foldtext for Neovim < 0.10.0
function utils.foldtext()
  return vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1]
end

-- extracted from the GOAT: folke
-- this code is definitely not mine
-- optimized treesitter foldexpr for Neovim >= 0.10.0
function utils.foldexpr()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b[buf].ts_folds == nil then
    -- as long as we don't have a filetype, don't bother
    -- checking if treesitter is available (it won't)
    if vim.bo[buf].filetype == "" then
      return "0"
    end
    if vim.bo[buf].filetype:find("dashboard") then
      vim.b[buf].ts_folds = false
    else
      vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
    end
  end
  return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"
end

return utils
