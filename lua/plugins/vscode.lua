return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("vscode").setup({
      transparent = false, -- set to true if you want transparent background
      italic_comments = true,
    })
    require("vscode").load()
  end,
}
