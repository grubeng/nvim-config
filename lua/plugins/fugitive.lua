return {
  "tpope/vim-fugitive",
  cmd = { "G", "Git", "Gdiffsplit", "Gvdiffsplit", "Gclog", "Gedit", "Gblame" },
  keys = {
    {
      "<leader>gD",
      ":<C-u>execute 'Gvdiffsplit HEAD~'.v:count1.':%'<CR>",
      desc = "Diff current file vs N commits back",
    },
    { "<leader>gH", ":Gclog -- %<CR>:copen<CR>", desc = "Show commit history for file" },
    { "<leader>gB", ":G blame<CR>",              desc = "Git blame current file (fugitive)" },
    { "<leader>gs", ":Git<CR>",                  desc = "Git status" },
  },
}
