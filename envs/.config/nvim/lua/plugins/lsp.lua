return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp = require("cmp")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require("lspconfig")

        require("fidget").setup()
        require("mason").setup()

        require("mason-lspconfig").setup({
            ensure_installed = {
                "ts_ls",   -- typescript-language-server
                "volar",   -- vue language server
                "html",
                "cssls",
                "eslint",
                "clangd",
            },
        })

        -- TypeScript + Vue setup
        lspconfig.ts_ls.setup({
            capabilities = capabilities,
            init_options = {
                plugins = {
                    {
                        name = "@vue/typescript-plugin",
                        -- ⚠️ Adjust this path depending on your system / npm prefix
                        location = "/usr/lib/node_modules/@vue/language-server",
                        languages = { "vue" },
                    },
                },
            },
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        })

        lspconfig.volar.setup({
            capabilities = capabilities,
        })

        -- Default servers
        local servers = { "html", "cssls", "eslint", "clangd" }
        for _, server in ipairs(servers) do
            lspconfig[server].setup({
                capabilities = capabilities,
            })
        end

        -- nvim-cmp setup
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
    end,
}
