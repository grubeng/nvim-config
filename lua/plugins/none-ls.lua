return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        require("none-ls.diagnostics.eslint_d"),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd.with({
          prefer_local = "node_modules/.bin",
        }),
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          -- Store group name globally so we can refer to it later
          local group = vim.api.nvim_create_augroup("FormatOnSave", { clear = false })
          vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = group,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false, bufnr = bufnr })
            end,
          })
        end
      end,
    })

    -- Manual format
    vim.keymap.set("n", "<leader>gf", function()
      vim.lsp.buf.format({ async = false })
    end, { desc = "Format file" })

    -- Save without formatting
    vim.keymap.set("n", "<leader>W", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local group_name = "FormatOnSave"
      -- Temporarily remove format-on-save
      vim.api.nvim_clear_autocmds({ group = group_name, buffer = bufnr })
      -- Save the buffer
      vim.cmd("write")
      -- Recreate the formatting autocmd after saving
      local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
      for _, client in ipairs(clients) do
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup(group_name, { clear = false }),
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false, bufnr = bufnr })
            end,
          })
          break
        end
      end
    end, { desc = "Save without formatting" })
  end,
}
