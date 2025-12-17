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

            -- Pick ONE client that supports rename (avoids multi-client encoding weirdness)
            local clients = vim.lsp.get_clients({ bufnr = 0, method = "textDocument/rename" })
            local client = clients[1]
            if not client then
              vim.notify("No LSP client attached that supports rename", vim.log.levels.WARN)
              return
            end

            local enc = client.offset_encoding or "utf-16"

            local function collect_uris(edit)
              local uris = {}

              if edit and edit.changes then
                for uri, _ in pairs(edit.changes) do
                  uris[uri] = true
                end
              end

              if edit and edit.documentChanges then
                for _, dc in ipairs(edit.documentChanges) do
                  -- TextDocumentEdit
                  if dc.textDocument and dc.textDocument.uri then
                    uris[dc.textDocument.uri] = true
                  end
                  -- Resource operations (rename/create/delete)
                  if dc.kind == "rename" then
                    if dc.oldUri then
                      uris[dc.oldUri] = true
                    end
                    if dc.newUri then
                      uris[dc.newUri] = true
                    end
                  elseif dc.kind == "create" or dc.kind == "delete" then
                    if dc.uri then
                      uris[dc.uri] = true
                    end
                  end
                end
              end

              local out = {}
              for uri, _ in pairs(uris) do
                table.insert(out, uri)
              end
              return out
            end

            local function save_affected_buffers(uris)
              local saved = 0

              for _, uri in ipairs(uris) do
                local bufnr = vim.uri_to_bufnr(uri)
                if bufnr and bufnr ~= 0 then
                  -- Load if needed (apply_workspace_edit may touch unloaded files)
                  pcall(vim.fn.bufload, bufnr)

                  -- Only write "real" file buffers
                  if vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_get_name(bufnr) ~= "" then
                    -- :update writes only if modified (safer than :write)
                    local ok = pcall(vim.api.nvim_buf_call, bufnr, function()
                      vim.cmd("silent! update")
                    end)
                    if ok then
                      saved = saved + 1
                    end
                  end
                end
              end

              return saved
            end

            local params = vim.lsp.util.make_position_params(0, enc)
            params.newName = new_name

            client.request("textDocument/rename", params, function(err, result, ctx)
              if err then
                vim.notify("Rename failed: " .. (err.message or tostring(err)), vim.log.levels.ERROR)
                return
              end

              if not result then
                vim.notify("Rename returned no result", vim.log.levels.WARN)
                return
              end

              local uris = collect_uris(result)

              -- Apply edits
              vim.lsp.util.apply_workspace_edit(result, enc)

              -- Save all affected buffers
              local saved = save_affected_buffers(uris)

              vim.notify(("Renamed to '%s' and saved %d buffer(s)"):format(new_name, saved), vim.log.levels.INFO)
            end, 0)
          end)
        end, { desc = "LSP rename + save all affected buffers" })
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
