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

        -- Define server configs
        vim.lsp.config.ts_ls = {
            capabilities = capabilities,
            init_options = {
                plugins = {
                    {
                        name = "@vue/typescript-plugin",
                        location = "/home/levi/.nvm/versions/node/v22.20.0/lib/node_modules/@vue/language-server", -- adjust if needed
                        languages = { "vue" },
                    },
                },
            },
            filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
        }

        vim.lsp.config.volar = {
            capabilities = capabilities,
        }

        local servers = { "html", "cssls", "eslint", "clangd" }
        for _, server in ipairs(servers) do
            vim.lsp.config[server] = {
                capabilities = capabilities,
            }
        end

        -- Start servers automatically for installed ones
        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    local config = vim.lsp.config[server_name] or {}
                    vim.lsp.start(config)
                end,
            },
        })

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
