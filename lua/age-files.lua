-- Password-protected *.age files: opening one asks for the password and shows
-- the decrypted text, :w encrypts it again. The plaintext only ever lives in
-- the buffer: no swap/undo file, and shada is switched off for the session.
--
-- The password goes to age through age-plugin-batchpass (age >= 1.3), because
-- age itself only reads passwords from the terminal, which Neovim is using.
-- The files are normal `age -p` files: `age -d notes.md.age` works too.

local group = vim.api.nvim_create_augroup("AgeFiles", { clear = true })

local function age(args, password, stdin)
  local cmd = vim.list_extend({ "age", "-j", "batchpass" }, args)
  return vim.system(cmd, { env = { AGE_PASSPHRASE = password }, stdin = stdin }):wait()
end

local function err(msg)
  vim.notify(msg, vim.log.levels.ERROR, { title = "age" })
end

-- Keep the plaintext off the disk: swap and undo files hold buffer text, and
-- shada stores registers (anything yanked from the file) when nvim exits.
local function protect(buf)
  vim.bo[buf].swapfile = false
  vim.bo[buf].undofile = false
  vim.o.shada = ""
end

vim.api.nvim_create_autocmd("BufReadCmd", {
  group = group,
  pattern = "*.age",
  desc = "Decrypt password-protected age file",
  callback = function(ev)
    local buf, file = ev.buf, ev.match
    protect(buf)
    -- Reset what a previous failed attempt left behind, so :e can retry.
    vim.bo[buf].modifiable = true
    vim.b[buf].age_locked = nil
    -- notes.md.age gets markdown highlighting
    local ft = vim.filetype.match({ filename = file:gsub("%.age$", ""), buf = buf })
    if ft then vim.bo[buf].filetype = ft end

    -- Missing or empty file: start blank, the password is chosen on first :w.
    local fh = io.open(file, "rb")
    local head = fh and fh:read(34) or nil
    if fh then fh:close() end
    if not head then return end

    -- Plain text that isn't encrypted yet: show it as is, :w encrypts it.
    if not (vim.startswith(head, "age-encryption.org/v1") or head == "-----BEGIN AGE ENCRYPTED FILE-----") then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(file))
      vim.bo[buf].modified = false
      vim.notify("Not encrypted yet: :w will ask for a password and encrypt it", vim.log.levels.WARN, { title = "age" })
      return
    end

    local password = vim.fn.inputsecret("Password for " .. vim.fn.fnamemodify(file, ":t") .. ": ")
    local res = password ~= "" and age({ "-d", file }, password) or nil
    if not res or res.code ~= 0 then
      -- Lock the empty buffer: saving it would replace the file with nothing.
      vim.b[buf].age_locked = true
      vim.bo[buf].modifiable = false
      err((res and vim.trim(res.stderr) or "No password given") .. "\nRun :e to try again.")
      return
    end

    vim.b[buf].age_password = password
    local text = res.stdout:gsub("\n$", "")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(text, "\n", { plain = true }))
    vim.bo[buf].modified = false
  end,
})

vim.api.nvim_create_autocmd("BufWriteCmd", {
  group = group,
  pattern = "*.age",
  desc = "Encrypt buffer to password-protected age file",
  callback = function(ev)
    local buf, file = ev.buf, ev.match
    if vim.b[buf].age_locked then
      err("Not saved: this file was never decrypted. Run :e to try again.")
      return
    end
    local password = vim.b[buf].age_password
    if not password then
      password = vim.fn.inputsecret("New password: ")
      if password == "" or password ~= vim.fn.inputsecret("Repeat password: ") then
        err("Passwords empty or different, nothing saved")
        return
      end
      vim.b[buf].age_password = password
    end

    local text = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n") .. "\n"
    local res = age({ "-e" }, password, text)
    if res.code ~= 0 then
      err("Encryption failed, nothing saved: " .. vim.trim(res.stderr))
      return
    end
    -- Only touch the file once encryption succeeded, so a failure can't wipe it.
    local out = assert(io.open(file, "wb"))
    out:write(res.stdout)
    out:close()

    if vim.api.nvim_buf_get_name(buf) == file then vim.bo[buf].modified = false end
    vim.notify("Encrypted " .. vim.fn.fnamemodify(file, ":~:."), vim.log.levels.INFO, { title = "age" })
  end,
})
