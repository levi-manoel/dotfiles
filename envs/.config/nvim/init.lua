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
vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

vim.opt.mouse=""
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = 'unnamedplus'

local function get_color_scheme()
    local gtk_theme = os.getenv("GTK_THEME")

    if gtk_theme and gtk_theme:lower():find("dark") then
        return 'colorscheme rose-pine-moon'
    else
        return 'colorscheme rose-pine-dawn'
    end
end

pcall(vim.cmd, get_color_scheme())
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

