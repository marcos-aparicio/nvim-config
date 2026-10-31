return {
  {
    "RedsXDD/neopywal.nvim",
    name = "neopywal",
    lazy = false,
    priority = 1000,
    config = function()
      local neopywal = require("neopywal")
      neopywal.setup()

      -- Wallust writes the palette to ~/.cache/wal/colors-wal.vim (see wallust.toml),
      -- which is the palette file neopywal reads by default. Neopywal's "light" variant
      -- is not a real palette: it HSL-inverts the palette (see neopywal.utils.light),
      -- and its generic load (`:colorscheme neopywal`) picks the variant from
      -- vim.o.background, so a light wallust palette can end up inverted or applied
      -- under the wrong background (documented in the upstream README).
      -- Since wallust already generates a faithful light palette, the raw
      -- ("neopywal-dark") variant is always the correct one; instead we sync
      -- vim.o.background to the palette's actual brightness.
      local Compiler = require("neopywal.lib.compiler")
      local Palette = require("neopywal.lib.palette")
      local opts = require("neopywal.lib.config").compiler_opts
      local compiled_dark = opts.compile_path
        .. opts.path_sep
        .. opts.filename
        .. "-dark"
        .. opts.file_ext

      -- Approximate perceived brightness (0-255) of the palette background.
      local function luminance()
        local file = io.open(Palette.palette_metadata.dark.filepath, "r")
        if not file then return nil end
        local content = file:read("*a")
        file:close()
        local hex = content:match('let background = "#(%x%x%x%x%x%x)"')
        if not hex then return nil end
        local r = tonumber(hex:sub(1, 2), 16) or 0
        local g = tonumber(hex:sub(3, 4), 16) or 0
        local b = tonumber(hex:sub(5, 6), 16) or 0
        return (r * 299 + g * 587 + b * 114) / 1000
      end

      local function sync_background()
        local lum = luminance()
        if lum then
          vim.o.background = lum >= 128 and "light" or "dark"
        end
      end

      local function load_compiled()
        local f = assert(loadfile(compiled_dark), "could not load neopywal cache.")
        sync_background()
        f()
        -- The compiled chunk sets vim.g.colors_name directly, which does NOT fire
        -- the ColorScheme event (only the :colorscheme command does). Plugins like
        -- lualine re-derive their colors on ColorScheme, so fire it explicitly.
        vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name, modeline = false })
        -- (Re)start neopywal's palette-file watcher: it calls recompile() when
        -- wallust rewrites the palette file, so live themes keep applying.
        vim.schedule(function() require("neopywal.lib.reloader").init() end)
      end

      -- Recompile when the palette file is newer than the compiled cache (e.g. wallust
      -- ran while neovim was closed), then apply the raw palette.
      local function apply_theme()
        if vim.fn.getftime(compiled_dark) < Palette.getftime().dark then
          Compiler.compile()
        end
        load_compiled()
      end

      -- Both neopywal load paths (":colorscheme neopywal[-dark|-light]" and the
      -- recompile its palette-file watcher triggers on wallust changes) bypass
      -- M.load's background/variant logic and apply the raw wallust palette.
      neopywal.load = function() apply_theme() end
      Compiler.recompile = function(notify)
        if notify == nil then notify = true end
        for name, _ in pairs(package.loaded) do
          if name:match("^neopywal.") and not name:match("^neopywal.lib.") then
            package.loaded[name] = nil
          end
        end
        Compiler.compile()
        load_compiled()
        if notify then
          require("neopywal.utils.notify").info("Successfully compiled cache.")
        end
      end

      vim.cmd.colorscheme("neopywal-dark")
    end,
  },
}
