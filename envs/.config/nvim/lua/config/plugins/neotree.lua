-- neo-tree (nui.nvim + nvim-web-devicons + plenary in pack)
require("neo-tree").setup({
    close_if_last_window = true,
    filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true,
        filtered_items = {
            hide_dotfiles = false,
            show_hidden_count = false,
            hide_by_name = { ".git", ".DS_Store", "thumbs.db" },
        },
    },
})

vim.keymap.set("n", "<leader>pv", "<cmd>Neotree toggle<cr>", { desc = "File tree" })
