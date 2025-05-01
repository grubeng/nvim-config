return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = "dracula",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "filename" }, -- ✅ show filename in center,
        lualine_c = { "branch" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    })
  end,
}
