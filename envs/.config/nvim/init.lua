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
vim.opt.autoread = true

-- autoread only reloads after :checktime. Watch the file so an external save
-- shows up immediately, same as VS Code. Local edits still prompt.
local reload_changed = vim.api.nvim_create_augroup("reload_changed_files", { clear = true })
local file_watchers = {}
local ignore_watch_until = {}

local function stop_file_watch(buf)
    local handle = file_watchers[buf]
    if not handle then
        return
    end
    file_watchers[buf] = nil
    if not handle:is_closing() then
        handle:stop()
        handle:close()
    end
end

local function watch_file(buf, retry)
    stop_file_watch(buf)
    if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "" then
        return
    end
    local path = vim.api.nvim_buf_get_name(buf)
    if path == "" then
        return
    end
    if vim.fn.filereadable(path) ~= 1 then
        if not retry then
            vim.defer_fn(function()
                watch_file(buf, true)
            end, 50)
        end
        return
    end
    local handle = vim.uv.new_fs_event()
    if not handle then
        return
    end
    local ok = handle:start(path, {}, function()
        vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(buf) then
                stop_file_watch(buf)
                return
            end
            -- Atomic saves replace the inode, so the watch ends after one event.
            watch_file(buf, true)
            if vim.uv.now() < (ignore_watch_until[buf] or 0) then
                return
            end
            if vim.fn.getcmdwintype() == "" then
                vim.cmd.checktime(buf)
            end
        end)
    end)
    if ok ~= 0 then
        handle:close()
        return
    end
    file_watchers[buf] = handle
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufFilePost", "BufWritePost" }, {
    group = reload_changed,
    callback = function(ev)
        if ev.event == "BufWritePost" then
            ignore_watch_until[ev.buf] = vim.uv.now() + 200
        end
        watch_file(ev.buf)
    end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
    group = reload_changed,
    callback = function(ev)
        stop_file_watch(ev.buf)
        ignore_watch_until[ev.buf] = nil
    end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "VimResume" }, {
    group = reload_changed,
    callback = function()
        if vim.fn.getcmdwintype() == "" then
            vim.cmd("checktime")
        end
    end,
})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set({ "n", "v" }, "x", '"_x', { noremap = true })
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
require("config.plugins.neotree")
require("config.plugins.markview")

require("config.plugins.colors").apply_theme_from_env()
