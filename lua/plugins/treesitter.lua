return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  condig = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = { "lua", "javascript", "typescript", "html", "css" },
      highlith = { enable = true },
      indent = { enable = true },
    })
  end,
}
