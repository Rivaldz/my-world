return {
  -- Existing GitHub Copilot.vim
  {
    "github/copilot.vim",
    enabled = true,
    event = "InsertEnter",
    config = function()
      -- Accept Copilot suggestion with <Right>
      vim.api.nvim_set_keymap("i", "<Right>", 'copilot#Accept("")', {
        expr = true,
        silent = true,
        noremap = true,
        replace_keycodes = false,
      })
    end,
  },

  -- CopilotChat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    enabled = true,
    dependencies = {
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    build = "make tiktoken",
    opts = {
      -- Configure CopilotChat if you want
    },
  },

  -- Windsurf (disabled)
  {
    "Exafunction/windsurf.vim",
    enabled = false,
    config = function()
      -- Example keymaps for Codeium (disabled plugin)
      vim.keymap.set("i", "<Right>", function()
        return vim.fn["codeium#Accept"]()
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<Down>", function()
        return vim.fn
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<Up>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })
      vim.keymap.set("i", "<Left>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })
    end,
  },

  -- Avante.nvim
  {
    "yetone/avante.nvim",
    -- If you want to build from source, set BUILD_FROM_SOURCE=true
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false, -- Do not set this to "*"
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "stevearc/dressing.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        -- Render markdown in Avante sidebar
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      -- This file can contain project-specific instructions
      instructions_file = "avante.md",

      -- "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | custom
      -- REKOMENDASI: Ganti provider ke "openai" untuk pengalaman seperti Cursor IDE
      provider = "openai",

      providers = {
        -- CLAUDE 3.5 SONNET (Versi terbaru, digunakan Cursor IDE)
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-5-20250929", -- Model terbaru Claude 3.5 Sonnet
          timeout = 35000,
          extra_request_body = {
            temperature = 0.5,
            max_tokens = 8192, -- Increased for better responses
          },
        },

        -- GPT-4o (RECOMMENDED - Model terbaru OpenAI, digunakan Cursor IDE)
        -- Model yang valid: gpt-4o, gpt-4o-mini, gpt-4-turbo, gpt-4, gpt-3.5-turbo
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-5-mini", -- Model OpenAI yang valid
          timeout = 35000,
          extra_request_body = {
            temperature = 0.5,
            max_completion_tokens = 30384,
          },
        },

        gpt_41_mini = {
          endpoint = "https://api.openai.com/v1",
          __inherited_from = "openai",
          model = "gpt-4.1-mini", -- Model OpenAI yang valid
          timeout = 35000,
          extra_request_body = {
            temperature = 0.5,
            max_tokens = 30384,
          },
        },

        gpt_52 = {
          endpoint = "https://api.openai.com/v1",
          __inherited_from = "openai",
          model = "gpt-5.2", -- Model OpenAI yang valid
          timeout = 35000,
          extra_request_body = {
            temperature = 0.5,
            max_completion_tokens = 30384,
          },
        },

        -- DEEPSEEK CODER (Specialized untuk coding, sangat murah/gratis)
        -- Alternatif bagus jika ingin hemat biaya
        deepseek = {
          endpoint = "https://api.deepseek.com/v1",
          model = "deepseek-coder",
          timeout = 30000,
          extra_request_body = {
            temperature = 0.5,
            max_tokens = 4096,
          },
        },

        -- DEEPSEEK CHAT (Model chat general purpose dari DeepSeek)
        deepseek_chat = {
          endpoint = "https://api.deepseek.com/v1",
          model = "deepseek-chat",
          timeout = 30000,
          extra_request_body = {
            temperature = 0.5,
            max_tokens = 4096,
          },
        },

        -- MOONSHOT (Kimi - Model China yang bagus)
        moonshot = {
          endpoint = "https://api.moonshot.ai/v1",
          model = "kimi-k2-0711-preview",
          timeout = 30000,
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 32768,
          },
        },
      },

      -- Optional: keep default keymaps and behavior
      behaviour = {
        auto_suggestions = false, -- Safer off at first
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
      },
    },
    -- Optional: explicit keymaps similar to LazyVim extra
    keys = {
      { "<leader>aa", "<cmd>AvanteAsk<CR>",            desc = "Ask Avante" },
      { "<leader>ac", "<cmd>AvanteChat<CR>",           desc = "Chat with Avante" },
      { "<leader>ae", "<cmd>AvanteEdit<CR>",           desc = "Edit with Avante" },
      { "<leader>af", "<cmd>AvanteFocus<CR>",          desc = "Focus Avante" },
      { "<leader>ah", "<cmd>AvanteHistory<CR>",        desc = "Avante History" },
      { "<leader>am", "<cmd>AvanteModels<CR>",         desc = "Select Avante Model" },
      { "<leader>an", "<cmd>AvanteChatNew<CR>",        desc = "New Avante Chat" },
      { "<leader>ap", "<cmd>AvanteSwitchProvider<CR>", desc = "Switch Avante Provider" },
      { "<leader>ar", "<cmd>AvanteRefresh<CR>",        desc = "Refresh Avante" },
      { "<leader>as", "<cmd>AvanteStop<CR>",           desc = "Stop Avante" },
      { "<leader>at", "<cmd>AvanteToggle<CR>",         desc = "Toggle Avante" },
    },
  },
}
