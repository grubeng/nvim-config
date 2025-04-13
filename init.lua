local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

local opts = {}  
require("lazy").setup("plugins", opts)

require("vim-options") 
