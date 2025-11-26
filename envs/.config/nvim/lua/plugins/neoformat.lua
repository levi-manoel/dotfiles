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

        local function run_prettier_npx()
            local filepath = vim.fn.expand('%')

            if filepath == '' then
                print("Buffer has no file path.")
                return
            end

            vim.cmd('write')

            local output = vim.fn.system('npx prettier --write ' .. vim.fn.shellescape(filepath))

            if vim.v.shell_error ~= 0 then
                print("Prettier Error: " .. output)
            else
                vim.cmd('edit')
                print("Prettier formatted: " .. filepath)
            end
        end

        vim.api.nvim_create_user_command('PrettierNpx', run_prettier_npx, {})

        vim.keymap.set('n', '<leader>p', run_prettier_npx, { desc = 'Run npx prettier --write' })
    end,
}

