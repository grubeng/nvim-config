return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window
  },
  lazy = false,
  opts = {},
  config = function()
    vim.keymap.set("n", "<C-b>", function()
      -- Toggles Neo-tree
      vim.cmd("Neotree toggle left")
    end, { desc = "Toggle Neo-tree" })
  end,
}

