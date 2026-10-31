-- DeepL translation of the visual selection (or the word under the cursor),
-- shown in a floating window. Reads the key from $DEEPL_API_KEY so it never
-- lands in this repo. Free-tier keys end in ":fx" and use the api-free host.
--
--   :Deepl          translate to vim.g.deepl_target_lang (default "EN-US")
--   :Deepl FR       translate to an explicit target language
--   <leader>T       same as :Deepl, in normal or visual mode
local M = {}

local function get_text(range)
  if range > 0 then
    local lines = vim.fn.getregion(vim.fn.getpos("'<"), vim.fn.getpos("'>"), { type = vim.fn.visualmode() })
    return table.concat(lines, "\n")
  end
  return vim.fn.expand("<cword>")
end

local function show(lines)
  vim.lsp.util.open_floating_preview(lines, "markdown", { border = "rounded", focus_id = "deepl" })
end

function M.translate(text, target)
  local key = os.getenv("DEEPL_API_KEY")
  if not key or key == "" then
    vim.notify("DeepL: $DEEPL_API_KEY is not set", vim.log.levels.ERROR)
    return
  end
  if text == "" then
    return
  end

  local host = key:match(":fx$") and "api-free.deepl.com" or "api.deepl.com"
  local body = vim.json.encode({ text = { text }, target_lang = target })

  vim.system({
    "curl", "-sS", "--fail-with-body",
    "-H", "Authorization: DeepL-Auth-Key " .. key,
    "-H", "Content-Type: application/json",
    "--data-binary", "@-",
    "https://" .. host .. "/v2/translate",
  }, { stdin = body, text = true }, vim.schedule_wrap(function(res)
    local ok, decoded = pcall(vim.json.decode, res.stdout or "")
    if res.code ~= 0 or not ok or not decoded.translations then
      local msg = ok and decoded.message or vim.trim((res.stderr or "") .. (res.stdout or ""))
      vim.notify("DeepL: " .. msg, vim.log.levels.ERROR)
      return
    end
    local t = decoded.translations[1]
    local lines = vim.split(t.text, "\n")
    table.insert(lines, 1, ("**%s → %s**"):format(t.detected_source_language, target))
    show(lines)
  end))
end

vim.api.nvim_create_user_command("Deepl", function(args)
  local target = (args.fargs[1] or vim.g.deepl_target_lang or "EN-US"):upper()
  M.translate(get_text(args.range), target)
end, { nargs = "?", range = true, desc = "Translate selection/word with DeepL" })

vim.keymap.set("n", "<leader>T", "<cmd>Deepl<CR>", { desc = "DeepL: translate word" })
vim.keymap.set("x", "<leader>T", ":Deepl<CR>", { desc = "DeepL: translate selection" })

return M
