-- github/copilot.vim
vim.g.copilot_node_command = (function()
    local node = vim.fn.exepath("node")
    if node ~= nil and node ~= "" then
        return node
    end
    return "node"
end)()
vim.g.copilot_filetypes = { ["*"] = true }
