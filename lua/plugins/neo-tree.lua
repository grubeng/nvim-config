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
  opts = {
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false, -- optional: close folders not related to current file
      },
      hijack_netrw_behavior = "open_default",
      use_libuv_file_watcher = true, -- enables real-time updates
    },
  },
  config = function()
    vim.keymap.set("n", "<C-b>", function()
      vim.cmd("Neotree toggle left reveal") -- reveal ensures file is shown + folders opened
    end, { desc = "Toggle Neo-tree and reveal current file" })
  end,
}
