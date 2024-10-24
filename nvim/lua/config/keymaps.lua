vim.api.nvim_set_keymap("i", "jf", "<Esc>", { noremap = true, silent = true })

--
local keymap = vim.keymap

local opts = { noremap = true, silent = true }
local silentF = { noremap = true, silent = false }
keymap.set("n", "<leader>e", "<C-w>l", opts)
keymap.set("n", "<leader>v", "<C-v>", opts)
keymap.set("n", "<leader>q", "<C-w>h", opts)
keymap.set("n", "<leader>k", "<C-w>k", opts)
keymap.set("n", "<leader>j", "<C-w>j", opts)
keymap.set("n", "sp", ":vsplit<CR>")

-- Keymaps for barbar plugin
keymap.set("n", "tp", ":BufferMovePrevious<CR>")
keymap.set("n", "tn", ":BufferMoveNext<CR>")
keymap.set("n", "nc", ":BufferClose<CR>")
keymap.set("n", "<leader>1", ":BufferGoto 1<CR>", opts)
keymap.set("n", "<leader>2", ":BufferGoto 2<CR>", opts)
keymap.set("n", "<leader>4", ":BufferGoto 4<CR>", opts)
keymap.set("n", "<leader>3", ":BufferGoto 3<CR>", opts)
keymap.set("n", "<leader>5", ":BufferGoto 5<CR>", opts)
keymap.set("n", "<leader>6", ":BufferGoto 6<CR>", opts)
keymap.set("n", "<leader>7", ":BufferGoto 7<CR>", opts)
keymap.set("n", "<leader>8", ":BufferGoto 8<CR>", opts)
keymap.set("n", "<leader>9", ":BufferGoto 9<CR>", opts)
keymap.set("n", "<leader>0", ":BufferLast<CR>", opts)

-- Keymaps for telescope
local builtin = require("telescope.builtin")
keymap.set("n", "<leader>fw", builtin.grep_string, { noremap = true, desc = "Telescope find files under cursor" })
keymap.set("n", "<leader>p", builtin.find_files, { noremap = true, desc = "telescope live grep" })

-- Keybindings for LSP
keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- Go to definition
keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- Show hover info
keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts) -- Rename symbol
keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- Go to implementation
keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts) -- List references

-- This For Auto Format 
vim.api.nvim_set_keymap('n', '<leader>s', '<cmd>lua vim.lsp.buf.format()<CR>', { noremap = true, silent = true })
