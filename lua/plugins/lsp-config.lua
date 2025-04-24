return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      -- Helper: format on save + keymaps
      local on_attach = function(client, bufnr)
        -- Format on save

        -- Format on save using null-ls and prettierd
        -- if client.server_capabilities.documentFormattingProvider then
        --  vim.api.nvim_create_autocmd("BufWritePre", {
        --    buffer = bufnr,
        --    callback = function()
        --      vim.lsp.buf.format({ async = false })
        --    end,
        --  })
        -- end

        -- LSP Keymaps
        local opts = { buffer = bufnr, desc = "" }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover doc" }))
        vim.keymap.set(
          "n",
          "<leader>gd",
          vim.lsp.buf.definition,
          vim.tbl_extend("force", opts, { desc = "Go to definition" })
        )
        vim.keymap.set(
          "n",
          "<leader>gr",
          vim.lsp.buf.references,
          vim.tbl_extend("force", opts, { desc = "Find references" })
        )
        vim.keymap.set(
          "n",
          "<leader>ca",
          vim.lsp.buf.code_action,
          vim.tbl_extend("force", opts, { desc = "Code action" })
        )

        -- 🔁 Rename with save
        vim.keymap.set("n", "<leader>rn", function()
          vim.lsp.buf.rename()
          vim.cmd("write")
        end, vim.tbl_extend("force", opts, { desc = "Rename symbol + save" }))
      end

      -- Setup LSP servers
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        init_options = {
          preferences = {
            importModuleSpecifierPreference = "relative",
            importModuleSpecifierEnding = "minimal",
          },
        },
      })

      lspconfig.solargraph.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.html.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Diagnostics config: inline + signs
      vim.diagnostic.config({
        virtual_text = {
          prefix = "●",
          spacing = 2,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Optional: define icons in gutter
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
}
