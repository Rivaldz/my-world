return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      git = {
        enable = true,
        ignore = false,
      },
      filters = {
        dotfiles = false,
        custom = { "node_modules" },
      },
    })

    local keymap = vim.keymap

    -- Map <leader>t to open the Nvim Tree
    keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

    -- Map <leader>f to focus on the Nvim Tree
    keymap.set("n", "<leader>f", ":NvimTreeFindFile<CR>", { noremap = true, silent = true })
  end,
}
