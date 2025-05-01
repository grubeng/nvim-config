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
        local opts = { buffer = bufnr, desc = "" }

        -- LSP Keymaps
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover doc" }))
        vim.keymap.set("n", "gl", function()
          vim.diagnostic.open_float(nil, { focusable = false })
        end, vim.tbl_extend("force", opts, { desc = "Show line diagnostics" }))
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

        vim.keymap.set("n", "<leader>rn", function()
          local curr_name = vim.fn.expand("<cword>")
          vim.ui.input({ prompt = "Rename to: ", default = curr_name }, function(new_name)
            if not new_name or #new_name == 0 or new_name == curr_name then
              return
            end

            local params = vim.lsp.util.make_position_params()
            params.newName = new_name

            vim.lsp.buf_request(0, "textDocument/rename", params, function(err, result, ctx, _)
              if err then
                vim.notify("Rename failed: " .. err.message, vim.log.levels.ERROR)
                return
              end

              -- Apply edits
              if result and result.changes then
                vim.lsp.util.apply_workspace_edit(result, "utf-8")
                vim.cmd("write")
                vim.notify("Renamed to '" .. new_name .. "' and saved", vim.log.levels.INFO)
              else
                vim.notify("Rename returned no changes", vim.log.levels.WARN)
              end
            end)
          end)
        end, { desc = "LSP rename + save when done" })
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

      -- Diagnostics config: no virtual text + signs
      vim.diagnostic.config({
        virtual_text = false, -- No inline text, errors in popup only
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Optional: define icons in gutter
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },
}
