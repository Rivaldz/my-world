-- disable whick key
return {

  { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { "folke/which-key.nvim",        enabled = false },

  { "akinsho/bufferline.nvim",     enabled = false },

  {
    "folke/flash.nvim",
    opts = {
      -- Disable the 't' key mapping
      modes = {
        char = {
          keys = {
            t = false, -- disable 't' key mapping
          },
        },
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- Disable the existing keymap for '<Space>s'
      { "<Space>s", false },
      -- Optionally, you can remap it to something else
      -- { "<leader>r", "<Cmd>Telescope registers<CR>", desc = "Open registers" }
    },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  { 'wakatime/vim-wakatime', lazy = false }
}
