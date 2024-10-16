-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.php" },
  callback = function()
    vim.lsp.buf.format({ async = true })
  end,
})
--vim.cmd([[

--  autocmd BufRead,BufNewFile *.blade.php set filetype=blade
--]])

-- Create autocmd for BufRead and BufNewFile events
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.blade.php",
  command = "setlocal filetype=blade.html",
})
