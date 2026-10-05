-- Filetype detection for chezmoi source files.
--
-- chezmoi encodes attributes in source names (dot_zshrc, executable_foo,
-- private_config.yml, mcp.json.tmpl), which hides the real name from
-- filetype detection. For any file inside the chezmoi source directory, work
-- out the name it deploys to and detect the filetype from THAT, so the usual
-- treesitter parser, LSP and ftplugins apply. Template syntax ({{ ... }})
-- itself is not highlighted.

-- Attribute prefixes chezmoi strips from a source name, in any order.
-- `literal_` stops prefix processing, exactly as chezmoi does.
local prefixes = {
  "after_", "before_", "create_", "empty_", "encrypted_", "exact_",
  "executable_", "external_", "modify_", "once_", "onchange_", "private_",
  "readonly_", "remove_", "run_", "symlink_",
}

local function target_name(component)
  local changed = true
  while changed do
    changed = false
    if vim.startswith(component, "literal_") then
      return component:sub(#"literal_" + 1)
    end
    for _, p in ipairs(prefixes) do
      if vim.startswith(component, p) then
        component = component:sub(#p + 1)
        changed = true
      end
    end
  end
  if vim.startswith(component, "dot_") then
    component = "." .. component:sub(#"dot_" + 1)
  end
  return component
end

-- `chezmoi source-path` once, on the first file opened; false = unavailable.
local root
local function source_root()
  if root == nil then
    local res = vim.system({ "chezmoi", "source-path" }, { text = true }):wait()
    root = res.code == 0 and vim.trim(res.stdout) .. "/" or false
  end
  return root
end

vim.filetype.add({
  pattern = {
    -- Not ".*": patterns are keyed by their text, and snacks.nvim's bigfile
    -- registers ".*" too, silently replacing this one. ".*/.*" matches the
    -- same full paths under a key nothing else uses.
    [".*/.*"] = {
      function(path, bufnr)
        local r = source_root()
        if not r or not vim.startswith(path, r) then
          return
        end
        local rel = path:sub(#r + 1):gsub("%.tmpl$", "")
        local parts = vim.tbl_map(target_name, vim.split(rel, "/", { plain = true }))
        local target = vim.fs.joinpath(vim.env.HOME, unpack(parts))
        return vim.filetype.match({ filename = target, buf = bufnr })
      end,
      { priority = math.huge },
    },
  },
})
