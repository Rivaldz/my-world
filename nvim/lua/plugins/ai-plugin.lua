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
      provider = "openai",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-5-20250929",
          -- model = "claude-3-5-haiku-20241022",
          timeout = 35000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.5,
            --max_tokens = 25480,
            max_tokens = 4096,
          },
        },

        -- OPENAI (ACTIVE)
        openai = {
          endpoint = "https://api.openai.com/v1",
          --model = "chatgpt-4o",
          --model ="gpt-4.1",
          model = "gpt-4o-mini",
          timeout = 35000,
          extra_request_body = {
            temperature = 0.5, -- better for coding
            max_tokens = 4096, -- cukup besar
            --max_completion_tokens = 2096, -- Use the correct parameter name
          },
        },
        openai1 = {
          endpoint = "https://api.openai.com/v1",
          --model = "chatgpt-4o",
          model = "gpt-4.1",
          timeout = 35000,
          extra_request_body = {
            temperature = 0.5, -- better for coding
            max_tokens = 4096, -- cukup besar
            --max_completion_tokens = 2096, -- Use the correct parameter name
          },
        },

        --Other Model
        moonshot = {
          endpoint = "https://api.moonshot.ai/v1",
          model = "kimi-k2-0711-preview",
          timeout = 30000, -- Timeout in milliseconds
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
