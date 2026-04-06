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

vim.lsp.config.ts_ls = {
    capabilities = capabilities,
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = (function()
                    local npm_root = vim.fn.trim(vim.fn.system("npm root -g 2>/dev/null"))
                    if npm_root ~= "" then
                        return npm_root .. "/@vue/language-server"
                    end
                    return "/usr/local/lib/node_modules/@vue/language-server"
                end)(),
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
    handlers = {
        function(server_name)
            local config = vim.lsp.config[server_name] or {}
            vim.lsp.start(config)
        end,
    },
})

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
