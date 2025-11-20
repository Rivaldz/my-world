return {
  {
    "jackMort/ChatGPT.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        openai_params = {
          model = "gpt-4.1-mini",
          temperature = 0.2,
          max_tokens = 1000,
        },
        openai_edit_params = {
          model = "gpt-4.1-mini",
          temperature = 0.3,
          top_p = 1,
        },
        chat = {
          welcome_message = WELCOME_MESSAGE,
          loading_text = "Loading, please wait ...",
          question_sign = "", -- you can customize symbols
          answer_sign = "ﮧ", -- use your favorite nerd font
          max_line_length = 120,
          sessions_window = {
            border = {
              style = "rounded",
              text = {
                top = " Sessions ",
              },
            },
          },
          keymaps = {
            close = { "<Esc>" },
            submit = "<C-Enter>",
            yank_last = "<C-y>",
            scroll_up = "<C-u>",
            scroll_down = "<C-d>",
            new_session = "<C-n>",
            cycle_windows = "<Tab>",
          },
        },
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  }
}
