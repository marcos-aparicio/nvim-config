return {
  handlers = {
    ['textDocument/publishDiagnostics'] = function(_, result, ctx)
      local ft
      local bufnr = ctx.bufnr
      if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
        ft = vim.bo[bufnr].filetype
      elseif result and result.uri then
        local fname = vim.uri_to_fname(result.uri)
        if fname:match("%.jsx?$") then
          ft = "javascript"
        elseif fname:match("%.tsx$") then
          ft = "typescriptreact"
        elseif fname:match("%.ts$") then
          ft = "typescript"
        end
      end
      if ft == "javascript" or ft == "javascriptreact" then
        result.diagnostics = {}
      end
      return vim.lsp.handlers['textDocument/publishDiagnostics'](nil, result, ctx)
    end
  }
}
