vim.api.nvim_set_keymap("i", "jf", "<Esc>", { noremap = true, silent = true })

local keymap = vim.keymap

local opts = { noremap = true, silent = true }
local silentF = { noremap = true, silent = false }
keymap.set("n", "<leader>e", "<C-w>l", opts)
keymap.set("n", "<leader>q", "<C-w>h", opts)
keymap.set("n", "<leader>v", "<C-v>", opts)

-- Keymaps for barbar plugin
keymap.set("n", "tp", ":BufferMovePrevious<CR>")
keymap.set("n", "tn", ":BufferMoveNext<CR>")
keymap.set("n", "nc", ":BufferClose<CR>", silentF)
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
