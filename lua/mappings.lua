local get_current_identifier_node_content = require("utils").get_current_identifier_node_content

local keymaps = {
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
