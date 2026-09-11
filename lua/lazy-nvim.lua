local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("core.plugins", {
  -- No background git fetches and no file watcher on the config directory.
  checker = { enabled = false },
  change_detection = { enabled = false },
  performance = {
    rtp = {
      -- Built-in runtime plugins that this config never uses. matchit and
      -- matchparen are deliberately kept: `%` on tags and paren highlighting.
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "rplugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
