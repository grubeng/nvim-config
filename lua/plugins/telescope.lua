return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      require("telescope").setup({
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!**/node_modules/*",
          },
          file_ignore_patterns = {
            "node_modules",
            "%.git/",
            "dist/",
            "build/",
          },
          mappings = {
            i = {
              ["<A-v>"] = actions.select_vertical,
              ["<A-s>"] = actions.select_horizontal,
              ["<A-t>"] = actions.select_tab,
            },
            n = {
              ["<A-v>"] = actions.select_vertical,
              ["<A-s>"] = actions.select_horizontal,
              ["<A-t>"] = actions.select_tab,
            },
          },
        },
      })

      vim.keymap.set("n", "<C-p>", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Search in current file" })
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      require("telescope").load_extension("ui-select")
    end,
  },
}
