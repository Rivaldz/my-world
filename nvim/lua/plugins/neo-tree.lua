return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, for icons
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      sources = { "buffers", "git_status" }, -- enable filesystem, buffers, and git status sources
      default_source = "buffers",
      window = {
        position = "right",                 -- place the Neo-tree window on the right
        width = 30,                         -- set the width of the window
      },
      filesystem = {
        filtered_items = {
          visible = true,                    -- show hidden files
          hide_dotfiles = false,             -- do not hide dotfiles
          hide_gitignored = false,           -- do not hide gitignored files
          hide_by_name = { "node_modules" }, -- custom hidden folders
        },
      },
      git_status = {
        symbols = {
          added     = "✚",
          modified  = "",
          deleted   = "✖",
          renamed   = "➜",
          untracked = "★",
          ignored   = "◌",
        },
      },
    })

    local keymap = vim.keymap

    -- Map <leader>t to toggle Neo-tree on the right side
    keymap.set("n", "<leader><Tab>", "<cmd>Neotree toggle right<cr>", { noremap = true, silent = true })

    -- Map <leader>f to focus filesystem in Neo-tree
    -- keymap.set("n", "<leader>f", "<cmd>Neotree focus filesystem right<cr>", { noremap = true, silent = true })
  end,
}
