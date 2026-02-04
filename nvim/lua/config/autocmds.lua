-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
vim.opt.fileformats = { "unix", "dos" }

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { "*.php" },
--   callback = function()
-- Check if the file is not a blade.php file
--     if not vim.fn.expand("%:t"):match("%.blade%.php$") then
--       vim.lsp.buf.format({ async = true })
--     end
--   end,
-- })
--vim.cmd([[

--  autocmd BufRead,BufNewFile *.blade.php set filetype=blade
--]])

-- Create autocmd for BufRead and BufNewFile events
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.blade.php",
  command = "setlocal filetype=blade.html",
})

vim.cmd([[highlight Normal guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight NonText guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight LineNr guibg=NONE ctermbg=NONE]])
vim.cmd([[highlight SignColumn guibg=NONE ctermbg=NONE]])

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "sql.migration" },
  callback = function()
    vim.b.omni_func = ""
    pcall(vim.api.nvim_buf_del_keymap, 0, "i", "<Right>")
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "AvanteWrite",
  callback = function()
    vim.cmd("silent! write!")
  end,
})
