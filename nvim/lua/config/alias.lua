vim.api.nvim_create_user_command("Terv", function()
  vim.cmd("vsp | term") -- Membuka terminal di vertical split
end, {})

vim.api.nvim_create_user_command("Terh", function()
  vim.cmd("sp | term") -- Membuka terminal di vertical split
end, {})
