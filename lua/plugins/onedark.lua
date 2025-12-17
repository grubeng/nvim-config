return {
  "navarasu/onedark.nvim",
  lazy = false,
  priority = 1000, --load before everything else
  config = function()
     require("onedark").setup({
       style = "dark", --Choose: dark, darker, cool, deep, warm, warmer, light
     })
     require("onedark").load()
  end,
}
