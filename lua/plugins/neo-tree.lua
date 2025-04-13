return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false, ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {},
  config = function()
    vim.keymap.set("n", "<C-b>", ":Neotree filesystem reveal left")
  end,
}
