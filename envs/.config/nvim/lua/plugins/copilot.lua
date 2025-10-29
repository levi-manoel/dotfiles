return {
    "github/copilot.vim",

    config = function()
        vim.g.copilot_node_command = "/home/levi/.nvm/versions/node/v22.20.0/bin/node"
        vim.g.copilot_filetypes = {
            ["*"] = true,
        }
    end,
}

