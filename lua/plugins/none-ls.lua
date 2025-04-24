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
          prefer_local = "node_modules/.bin", -- ✅ Use local prettier
        }),
      },
      -- ✅ Format on save
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          local group = vim.api.nvim_create_augroup("Format", { clear = false })
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
  end,
}

