local get_current_identifier_node_content = require("utils").get_current_identifier_node_content

local keymaps = {
  { "n", "<leader>mr", ":LspRestart marksman<CR>" },
  -- lazy commands
  { "n", "<leader>lp", ":Lazy profile<CR>" },
  --
  { "n", "<leader>w",  ":w<CR>" },
  {
    "n",
    "<leader>q",
    function()
      if vim.bo.filetype == "TelescopePrompt" then
        vim.cmd("quit!")
        return
      end
      if vim.bo.filetype == "qf" then
        vim.cmd("cclose")
        return
      end
      if vim.bo.filetype == "command_runner" then
        vim.cmd("q")
        return
      end
      if vim.bo.buftype == "terminal" then
        vim.cmd("bd!")
        return
      end
      vim.cmd("bd")
    end,
    { desc = "Custom closing of buffer" },
  },
  { "n",          "<leader>v",  ":vs<CR>" },
  { "n",          "<leader>h",  ":sp<CR>" },
  { "n",          ",",          "%" },
  { "n",          "<C-h>",      "<C-w>h" },
  { "n",          "<C-l>",      "<C-w>l" },
  { "n",          "<C-j>",      "<C-w>j" },
  { "n",          "<C-k>",      "<C-w>k" },
  -- better normal/visual mode movement
  { { "n", "v" }, "gl",         "g$" },
  { { "n", "v" }, "gh",         "g^" },
  { { "n", "v" }, "gt",         "gg" },
  { { "n", "v" }, "gb",         "G" },
  { "n",          "gL",         "$" },
  { "n",          "gH",         "^" },
  { "n",          "ygl",        "y$" },
  { "n",          "ygh",        "y^" },
  { "n",          "<C-Tab>",    ":tabnext<CR>" },
  { "n",          "<C-S-Tab>",  ":tabprevious<CR>" },
  { "n",          "<C-w>",      ":tabclose<CR>" },
  -- some positioning remappings
  { "n",          "zj",         "zt" },
  { "n",          "zk",         "zb" },
  -- some navigation normal remappings
  { "n",          "<leader>k",  ":b#<CR>" },
  { { "n", "v" }, "j",          "gj" },
  { { "n", "v" }, "k",          "gk" },
  { "n",          "<C-d>",      "<C-d>zz" },
  { "n",          "<C-u>",      "<C-u>zz" },
  { "n",          "<C-o>",      "<C-o>zz" },
  { "n",          "N",          "Nzzzv" },
  { "n",          "n",          "nzzzv" },
  -- better curly brackets manipulation
  { "n",          "dic",        "diB" },
  { "n",          "dac",        "daB" },
  { "n",          "cic",        "ciB" },
  { "n",          "cac",        "caB" },
  { "v",          "ic",         "iB" },
  { "v",          "ac",         "aB" },
  -- basic insert remappings
  { "i",          "kj",         "<Esc>" },
  { "i",          "<C-e>",      "<C-o>$" },
  { "i",          "<C-a>",      "<C-o>^" },
  -- { "i", "<C-d>", "<C-o>o" },
  { "i",          "<C-v>",      "<C-r>+" },
  -- better replacing and handle of commands
  { "n",          "<leader>.",  "@:<CR>" },
  { "n",          "<leader>S",  ":%s//gI<Left><Left><Left>" },
  { "n",          "<leader>s",  ":s//gI<Left><Left><Left>" },
  { "v",          "<leader>s",  ":s//g<Left><Left>" },
  { "n",          "<TAB>",      ">>" },
  { "n",          "<S-TAB>",    "<<" },
  { "i",          "<TAB>",      "<C-t>" },
  { "i",          "<S-TAB>",    "<C-d>" },
  { "v",          "<TAB>",      ">gv" },
  { "v",          "<S-TAB>",    "<gv" },
  -- terminal mappings
  { "t",          "<C-j>",      "<C-\\><C-N><C-w>j" },
  { "t",          "<C-k>",      "<C-\\><C-N><C-w>k" },
  { "t",          "<C-h>",      "<C-\\><C-N><C-w>h" },
  { "t",          "<C-n>",      "<C-\\><C-N>" },
  { "t",          "<C-q>",      "<C-\\><C-N>:bd!<CR>" },
  { "t",          "<C-S-h>",    "<C-\\><C-N>:vertical resize -2<CR>" },
  { "t",          "<C-S-j>",    "<C-\\><C-N>:resize +2<CR>" },
  { "t",          "<C-S-k>",    "<C-\\><C-N>:resize -2<CR>" },
  { "t",          "<C-S-l>",    "<C-\\><C-N>:vertical resize +2<CR>" },
  -- source current file
  { "n",          "<leader>x",  ":source %<CR>" },
  -- quickfix mappings
  { "n",          "<leader>co", ":copen<CR>" },
  { "n",          "<leader>cq", ":cclose<CR>" },
  { "n",          "<leader>cj", ":cnext<CR>" },
  { "n",          "<leader>ck", ":cprev<CR>" },
  -- resizing windows
  { "n",          "<C-S-h>",    ":vertical resize -2<CR>" },
  { "n",          "<C-S-j>",    ":resize -2<CR>" },
  { "n",          "<C-S-k>",    ":resize +2<CR>" },
  { "n",          "<C-S-l>",    ":vertical resize +2<CR>" },
  { "n",          "<leader>rr", ":ExecuteCurrentBuffer<CR>" },
  {
    "n",
    "<C-y>",
    function()
      vim.cmd(":%y+")
      print("Buffer copied to clipboard")
    end,
  },
}

for _, map in ipairs(keymaps) do
  local opts = { noremap = true, silent = true }
  if map[1] == "i" then
    opts = {}
  end
  -- Merge opts with map[4], if it exists
  local final_opts = map[4] and vim.tbl_extend("force", opts, map[4]) or opts
  vim.keymap.set(map[1], map[2], map[3], final_opts)
end

local autocmd = vim.api.nvim_create_autocmd
autocmd({ "FileType" }, {
  pattern = "php",
  callback = function()
    vim.keymap.set({ "n" }, "<leader>re", function()
      local name = get_current_identifier_node_content("method_declaration", "name")
      if not string.match(name, "test.*") then
        return
      end
      local current_file = vim.fn.expand("%:p")

      if string.match(current_file, ".*tests/Feature/.*%.php$") then
        vim.cmd(":vs")
        vim.cmd(":term vendor/bin/sail test % --filter " .. name)
        return
      end

      if string.match(current_file, ".*tests/Browser/.*%.php$") then
        vim.cmd(":vs")
        vim.cmd(":term vendor/bin/sail dusk % --filter " .. name)
        return
      end
    end)
  end,
})


-- This code is definitely not mine, shotout to linkarzu for this awesome mappings!
-- https://www.youtube.com/watch?v=EYczZLNEnIY
-- Folding Section --

-- Checks each line to see if it matches a markdown heading (#, ##, etc.):
-- It’s called implicitly by Neovim’s folding engine by vim.opt_local.foldexpr
function _G.markdown_foldexpr()
  local lnum = vim.v.lnum
  local line = vim.fn.getline(lnum)
  local heading = line:match("^(#+)%s")
  if heading then
    local level = #heading
    if level == 1 then
      -- Special handling for H1
      if lnum == 1 then
        return ">1"
      else
        local frontmatter_end = vim.b.frontmatter_end
        if frontmatter_end and (lnum == frontmatter_end + 1) then
          return ">1"
        end
      end
    elseif level >= 2 and level <= 6 then
      -- Regular handling for H2-H6
      return ">" .. level
    end
  end
  return "="
end

local function set_markdown_folding()
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "v:lua.markdown_foldexpr()"
  vim.opt_local.foldlevel = 99

  -- Detect frontmatter closing line
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local found_first = false
  local frontmatter_end = nil
  for i, line in ipairs(lines) do
    if line == "---" then
      if not found_first then
        found_first = true
      else
        frontmatter_end = i
        break
      end
    end
  end
  vim.b.frontmatter_end = frontmatter_end
end

-- Use autocommand to apply only to markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = set_markdown_folding,
})

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
  -- Move to the top of the file without adding to jumplist
  vim.cmd("keepjumps normal! gg")
  -- Get the total number of lines
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      -- Move the cursor to the current line without adding to jumplist
      vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
      -- Check if the current line has a fold level > 0
      local current_foldlevel = vim.fn.foldlevel(line)
      if current_foldlevel > 0 then
        -- Fold the heading if it matches the level
        if vim.fn.foldclosed(line) == -1 then
          vim.cmd("normal! za")
        end
        -- else
        --   vim.notify("No fold at line " .. line, vim.log.levels.WARN)
      end
    end
  end
end

local function fold_markdown_headings(levels)
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)
end

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 1 or above
vim.keymap.set("n", "zj", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfj", function()
  -- Reloads the file to refresh folds, otheriise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 1 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
vim.keymap.set("n", "zk", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfk", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 3 or above
vim.keymap.set("n", "zl", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfl", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 3 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 4 or above
vim.keymap.set("n", "z;", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mf;", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 4 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for unfolding markdown headings of level 2 or above
-- Changed all the markdown folding and unfolding keymaps from <leader>mfj to
-- zj, zk, zl, z; and zu respectively lamw25wmal
vim.keymap.set("n", "zu", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfu", function()
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  vim.cmd("normal! zR") -- Unfold all headings
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Unfold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- gk jummps to the markdown heading above and then folds it
-- zi by default toggles folding, but I don't need it lamw25wmal
vim.keymap.set("n", "zi", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- Difference between normal and normal!
  -- - `normal` executes the command and respects any mappings that might be defined.
  -- - `normal!` executes the command in a "raw" mode, ignoring any mappings.
  vim.cmd("normal gk")
  -- This is to fold the line under the cursor
  vim.cmd("normal! za")
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold the heading cursor currently on" })
