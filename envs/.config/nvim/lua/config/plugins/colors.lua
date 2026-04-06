-- Rosé Pine (rose-pine/neovim in pack/plugins/start/neovim)
-- Dark = moon, light = dawn. See ./pack/plugins/install.sh
local M = {}

local rose_ok, rose_pine = pcall(require, "rose-pine")

---@return '"dark"'|'"light"'
function M.get_theme_kind()
    local config_home = os.getenv("XDG_CONFIG_HOME")
    if not config_home or config_home == "" then
        config_home = (os.getenv("HOME") or "") .. "/.config"
    end
    local f = io.open(config_home .. "/theme.env", "r")
    if f then
        local content = f:read("*a") or ""
        f:close()
        local theme = content:match('THEME%s*=%s*"([^"]+)"')
        if theme == "light" then
            return "light"
        elseif theme == "dark" then
            return "dark"
        end
    end

    local gtk_theme = os.getenv("GTK_THEME")
    if gtk_theme and gtk_theme:lower():find("dark") then
        return "dark"
    end

    return "light"
end

--- Rosé Pine variant: moon | dawn
---@return string variant
function M.get_rose_variant()
    if M.get_theme_kind() == "dark" then
        return "moon"
    end
    return "dawn"
end

-- Dawn: boost contrast vs cream terminal bg (keywords were barely visible).
local dawn_high_contrast = {
    text = "#1e1c24",
    subtle = "#454253",
    muted = "#65607a",
    foam = "#0f5c6e",
    pine = "#0a5668",
    iris = "#3a2d4d",
    rose = "#a33d3d",
    gold = "#7a4f08",
    love = "#722f45",
    leaf = "#2d524a",
}

--- Treesitter keywords on dawn (const/import/async/etc.) — override pale iris links.
local dawn_keyword_fg = "#0f4f5c"
local dawn_keyword_groups = {
    ["@keyword"] = { fg = dawn_keyword_fg, inherit = false },
    ["@keyword.modifier"] = { fg = dawn_keyword_fg, inherit = false },
    ["@keyword.import"] = { fg = dawn_keyword_fg, inherit = false },
    ["@keyword.return"] = { fg = dawn_keyword_fg, inherit = false },
    ["@keyword.function"] = { fg = dawn_keyword_fg, inherit = false },
    ["@keyword.operator"] = { fg = dawn_keyword_fg, inherit = false },
    ["@keyword.exception"] = { fg = dawn_keyword_fg, inherit = false },
    ["@keyword.directive"] = { fg = dawn_keyword_fg, inherit = false },
    ["@keyword.repeat"] = { fg = dawn_keyword_fg, inherit = false },
    ["@keyword.storage"] = { fg = dawn_keyword_fg, inherit = false },
    ["@keyword.coroutine"] = { fg = dawn_keyword_fg, inherit = false },
    ["@keyword.type"] = { fg = dawn_keyword_fg, inherit = false },
}

--- List / float UI: netrw selection, Fidget, etc.
local function patch_ui_highlights()
    local kind = M.get_theme_kind()
    if kind == "light" then
        local line_bg = "#e6e2d8"
        local float_bg = "#f2eee4"
        local float_fg = "#2c2926"
        local border = "#b0aaa0"

        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { fg = float_fg, bg = float_bg })
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = border, bg = float_bg })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = line_bg, fg = "NONE" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { bg = line_bg, fg = "#5a554c" })
        vim.api.nvim_set_hl(0, "Visual", { bg = "#d5d0c5", fg = "NONE" })
        vim.api.nvim_set_hl(0, "QuickFixLine", { bg = line_bg, fg = "NONE" })
        vim.api.nvim_set_hl(0, "Pmenu", { bg = float_bg, fg = float_fg })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#c5d2d4", fg = "#1c1b19" })
        vim.api.nvim_set_hl(0, "PmenuThumb", { bg = border })
        vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = line_bg, fg = "#1a1918" })
        vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = "#1a1918", bg = line_bg })

        vim.api.nvim_set_hl(0, "FidgetNotifyNormal", { fg = float_fg, bg = float_bg })
        vim.api.nvim_set_hl(0, "FidgetNotifyGroup", { fg = "#1e4a5c", bg = float_bg, bold = true })
        vim.api.nvim_set_hl(0, "FidgetNotifyIcon", { fg = "#3d5c4a", bg = float_bg })
        vim.api.nvim_set_hl(0, "FidgetNotifyAnnote", { fg = "#5a5348", bg = float_bg })
        vim.api.nvim_set_hl(0, "Title", { fg = "#1e4a5c", bg = float_bg, bold = true })
        vim.api.nvim_set_hl(0, "Question", { fg = "#3d5c4a", bg = float_bg })
    else
        local line_bg = "#3d3d40"
        local float_bg = "#2a2a2d"
        local float_fg = "#dcd8d0"
        local border = "#6b6560"

        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { fg = float_fg, bg = float_bg })
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = border, bg = float_bg })
        vim.api.nvim_set_hl(0, "CursorLine", { bg = line_bg, fg = "NONE" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { bg = line_bg, fg = "#b8b3ab" })
        vim.api.nvim_set_hl(0, "Visual", { bg = "#4a4a52", fg = "NONE" })
        vim.api.nvim_set_hl(0, "QuickFixLine", { bg = line_bg, fg = "NONE" })
        vim.api.nvim_set_hl(0, "Pmenu", { bg = float_bg, fg = float_fg })
        vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#4a5a62", fg = "#f0ece4" })

        vim.api.nvim_set_hl(0, "FidgetNotifyNormal", { fg = float_fg, bg = float_bg })
        vim.api.nvim_set_hl(0, "FidgetNotifyGroup", { fg = "#8cb9c7", bg = float_bg, bold = true })
        vim.api.nvim_set_hl(0, "FidgetNotifyIcon", { fg = "#9dbc9b", bg = float_bg })
        vim.api.nvim_set_hl(0, "FidgetNotifyAnnote", { fg = "#a39e96", bg = float_bg })
    end
end

local function apply_rose_pine(variant)
    local opts = {
        variant = variant,
        dark_variant = "moon",
        dim_inactive_windows = false,
        extend_background_behind_borders = true,
        enable = {
            terminal = true,
            legacy_highlights = true,
            migrations = true,
        },
        styles = {
            italic = false,
            transparency = true,
        },
    }
    if variant == "dawn" then
        opts.palette = { dawn = dawn_high_contrast }
        opts.highlight_groups = dawn_keyword_groups
    end
    rose_pine.setup(opts)
    vim.o.background = variant == "dawn" and "light" or "dark"
    vim.cmd.colorscheme("rose-pine")
    patch_ui_highlights()
end

function ColorMyPencils(_ignored)
    local variant = M.get_rose_variant()
    if rose_ok then
        apply_rose_pine(variant)
    else
        vim.o.background = variant == "dawn" and "light" or "dark"
        local fb = variant == "dawn" and "zellner" or "habamax"
        vim.cmd.colorscheme(fb)
        patch_ui_highlights()
        if not M._warned_missing_rose then
            M._warned_missing_rose = true
            vim.notify(
                "rose-pine not installed — using builtin colorscheme. Run: "
                    .. vim.fn.expand("~/.config/nvim/pack/plugins/install.sh"),
                vim.log.levels.WARN
            )
        end
    end
end

function M.apply_theme_from_env()
    ColorMyPencils()
end

vim.api.nvim_create_augroup("theme-env-sync", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "VimResume" }, {
    group = "theme-env-sync",
    callback = function()
        M.apply_theme_from_env()
    end,
})

vim.api.nvim_create_user_command("ThemeReload", function()
    M.apply_theme_from_env()
end, { desc = "Re-read ~/.config/theme.env and apply Rosé Pine variant" })

return M
