require("config.lazy")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set({'n', 'v'}, 'x', '"_x', { noremap = true })
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)

vim.opt.mouse=""
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = 'unnamedplus'

pcall(vim.cmd, 'colorscheme rose-pine-moon')
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

