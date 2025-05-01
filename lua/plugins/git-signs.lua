return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  config = function()
    require("gitsigns").setup({
      current_line_blame = true, -- Blame info at the end of the line
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
        delay = 100,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      -- Optionally set keymaps for blame popup
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        vim.keymap.set("n", "<leader>gb", function()
          gs.blame_line({ full = true }) -- full popup with commit details
        end, { buffer = bufnr, desc = "Git blame full popup" })
      end,
    })
  end,
}
