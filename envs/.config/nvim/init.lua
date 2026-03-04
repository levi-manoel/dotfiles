-- Native pack: plugins live in pack/plugins/start/
-- Install with: ./pack/plugins/install.sh

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.opt.mouse = ""
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.clipboard = "unnamedplus"

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set({ "n", "v" }, "x", '"_x', { noremap = true })
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- Plugin configs (load after options; plugins are in pack/plugins/start/)
require("config.plugins.colors")
require("config.plugins.findAndReplace")
require("config.plugins.cellular_automation")
require("config.plugins.neoformat")
require("config.plugins.harpoon")
require("config.plugins.lsp")
require("config.plugins.copilot")
require("config.plugins.vimbegood")
require("config.plugins.undotree")
require("config.plugins.trouble")
require("config.plugins.treesitter")
require("config.plugins.telescope")

local function get_color_scheme()
    local gtk_theme = os.getenv("GTK_THEME")
    if gtk_theme and gtk_theme:lower():find("dark") then
        return "rose-pine-moon"
    else
        return "rose-pine-dawn"
    end
end

ColorMyPencils(get_color_scheme())
