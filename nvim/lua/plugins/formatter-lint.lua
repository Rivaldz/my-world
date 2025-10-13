return {
  -- Formatter: Conform
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo", "Format" },
    opts = {
      -- Do not fallback to LSP for formatting to avoid sqls re-formatting
      format_on_save = { timeout_ms = 2000, lsp_fallback = false },

      -- Choose pg_format first (very reliable for Postgres), fallback to sql-formatter
      formatters_by_ft = {
        sql = { "pg_format" },
        lua = { "stylua" },
        go = { "goimports", "gofumpt" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
      },

      -- Explicit formatter configs
      formatters = {
        -- Postgres-native; safest choice for your migrations
        pg_format = {
          stdin = true,
          -- Tune options here; keep it conservative
          prepend_args = {
            "--keyword-case", "2", -- 2 = UPPER
            "--spaces", "2",       -- indent width
            -- Remove the next line if you dislike comma-at-line-start style:
            -- "--comma-start",
          },
        },

        -- sql-formatter: keep CLI args minimal; advanced options via config file
        -- sql_formatter = {
        --   command = "sql-formatter",
        --   args = {
        --     "--language", "postgresql",
        --     -- If you add a project config: "-c", ".sql-formatter.json"
        --   },
        --   stdin = true, -- reads from STDIN automatically; no trailing "-"
        -- },

        -- Stylua: let it run only if Lua syntax is valid
        stylua = {
          -- no extra args; Stylua requires valid AST
        },
      },
    },
  },

  -- Linter: nvim-lint
  -- {
  --   "mfussenegger/nvim-lint",
  --   event = { "BufReadPost", "BufNewFile" },
  --   config = function()
  --     local lint = require("lint")
  --
  --     lint.linters_by_ft = {
  --       go = { "golangcilint" },
  --       javascript = { "eslint_d" },
  --       typescript = { "eslint_d" },
  --       json = { "eslint_d" },
  --       -- You can add sqlfluff here if you use it and have a proper .sqlfluff
  --       -- sql = { "sqlfluff" },
  --     }
  --
  --     -- Trigger lint on write/enter/changed
  --     vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  --       callback = function()
  --         -- Avoid spamming on huge files
  --         if vim.api.nvim_buf_line_count(0) < 20000 then
  --           require("lint").try_lint()
  --         end
  --       end,
  --     })
  --   end,
  -- },
}
