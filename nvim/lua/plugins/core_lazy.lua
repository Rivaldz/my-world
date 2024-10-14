-- disable whick key
return {
  { "folke/which-key.nvim", enabled = false },

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
}
