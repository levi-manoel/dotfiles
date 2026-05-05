-- LSP: mason, mason-lspconfig, nvim-cmp, fidget, sqls
local cmp = require("cmp")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("fidget").setup({
    notification = {
        window = {
            winblend = 0,
            border = "single",
            normal_hl = "FidgetNotifyNormal",
            group_style = "FidgetNotifyGroup",
            icon_style = "FidgetNotifyIcon",
            annote_style = "FidgetNotifyAnnote",
            border_hl = "FloatBorder",
        },
    },
})
require("mason").setup()

-- ts_ls must load @vue/typescript-plugin for .vue SFCs. `location` is the plugin
-- package root (folder named typescript-plugin), not @vue/language-server.
-- Global `npm i -g @vue/language-server` nests it under language-server/node_modules.
local function vue_typescript_plugin_dir()
    local npm_root = vim.fn.trim(vim.fn.system("npm root -g 2>/dev/null"))
    local candidates = {
        npm_root ~= "" and (npm_root .. "/@vue/typescript-plugin") or nil,
        npm_root ~= "" and (npm_root .. "/@vue/language-server/node_modules/@vue/typescript-plugin") or nil,
        "/usr/local/lib/node_modules/@vue/typescript-plugin",
        "/usr/local/lib/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
    }
    for _, p in ipairs(candidates) do
        if p and vim.fn.isdirectory(p) == 1 then
            return p
        end
    end
    return candidates[4] or "/usr/local/lib/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"
end

vim.lsp.config.ts_ls = {
    capabilities = capabilities,
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = vue_typescript_plugin_dir(),
                languages = { "vue" },
            },
        },
    },
    filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}

vim.lsp.config.lua_ls = {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
        },
    },
}

vim.lsp.config("sqls", {
    settings = {
        sqls = {
            connections = {
                {
                    driver = "mysql",
                    dataSourceName = "levi.manoel@tcp(127.0.0.1:3307)/irancho_production",
                },
            },
        },
    },
})
vim.lsp.enable("sqls")

local servers = { "html", "cssls", "eslint", "clangd" }
for _, server in ipairs(servers) do
    vim.lsp.config[server] = {
        capabilities = capabilities,
    }
end

-- Vue: ts_ls + @vue/typescript-plugin above (no separate volar package).
require("mason-lspconfig").setup({
    ensure_installed = {
        "ts_ls",
        "html",
        "cssls",
        "eslint",
        "clangd",
    },
})

vim.lsp.enable({ "ts_ls", "lua_ls", "html", "cssls", "eslint", "clangd" })

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-f>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = {
        { name = "nvim_lsp" },
    },
})
