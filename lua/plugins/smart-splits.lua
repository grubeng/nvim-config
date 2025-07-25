return {
  "mrjones2014/smart-splits.nvim",
  config = function()
    require("smart-splits").setup({})

    -- Moving between splits
    vim.keymap.set("n", "<C-h>", require("smart-splits").move_cursor_left)
    vim.keymap.set("n", "<C-j>", require("smart-splits").move_cursor_down)
    vim.keymap.set("n", "<C-k>", require("smart-splits").move_cursor_up)
    vim.keymap.set("n", "<C-l>", require("smart-splits").move_cursor_right)

    -- Resizing splits
    vim.keymap.set("n", "<A-h>", require("smart-splits").resize_left)
    vim.keymap.set("n", "<A-j>", require("smart-splits").resize_down)
    vim.keymap.set("n", "<A-k>", require("smart-splits").resize_up)
    vim.keymap.set("n", "<A-l>", require("smart-splits").resize_right)

    -- Alternative mappings for resizing splits
    vim.keymap.set("n", "<C-S-h>", require("smart-splits").resize_left)
    vim.keymap.set("n", "<C-S-j>", require("smart-splits").resize_down)
    vim.keymap.set("n", "<C-S-k>", require("smart-splits").resize_up)
    vim.keymap.set("n", "<C-S-l>", require("smart-splits").resize_right)
  end,
}
