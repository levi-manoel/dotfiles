return {
    "sbdchd/neoformat",
    init = function()
        vim.g.neoformat_try_node_exe = 1
    end,
    config = function()
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = { "*.ts", "*.js", "*.vue" },
            callback = function()
                vim.cmd("Neoformat")
            end,
        })
    end,
}

