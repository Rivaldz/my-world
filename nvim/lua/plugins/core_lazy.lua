-- disable whick key
return {
  -- { "nvim-neo-tree/neo-tree.nvim", enabled = false },
  { 'wakatime/vim-wakatime',   lazy = false },
  { "karb94/neoscroll.nvim",   enabled = false },
  { "folke/which-key.nvim",    enabled = false },
  { "akinsho/bufferline.nvim", enabled = false },

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
  {
    "nvim-mini/mini.icons",
    lazy = true,
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
        go = { glyph = "", hl = "MiniIconsAzure" }, -- override Go icon
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
