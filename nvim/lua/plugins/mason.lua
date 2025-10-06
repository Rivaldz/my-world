return {
  { "mason-org/mason.nvim", config = true },

  -- Mason <-> LSP bridge
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "b0o/schemastore.nvim",
    },
    opts = function()
      local lspconfig = require("lspconfig")

      -- Backward-compatible TS server name (ts_ls on new lspconfig, tsserver on older)
      local ts_name = lspconfig.ts_ls and "ts_ls" or "tsserver"

      return {
        automatic_installation = true,
        ensure_installed = {
          "intelephense",
          "html",
          "cssls",
          "lua_ls",
          "gopls",
          "pyright",
          "jsonls",
          ts_name,
        },

        -- <---- put handlers here, not via setup_handlers() ---->
        handlers = {
          -- default handler for any server without a dedicated one
          function(server)
            lspconfig[server].setup({})
          end,

          -- JSON: with schemastore
          ["jsonls"] = function()
            lspconfig.jsonls.setup({
              settings = {
                json = {
                  validate = { enable = true },
                  schemas = require("schemastore").json.schemas(),
                },
              },
              filetypes = { "json", "jsonc" },
            })
          end,

          -- HTML: disable formatting (use conform/prettier)
          ["html"] = function()
            lspconfig.html.setup({
              on_attach = function(client, _)
                client.server_capabilities.documentFormattingProvider = false
                client.server_capabilities.documentRangeFormattingProvider = false
              end,
            })
          end,

          -- TS/JS
          [ts_name] = function()
            lspconfig[ts_name].setup({
              on_attach = function(client, bufnr)
                client.server_capabilities.documentFormattingProvider = false
                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
              end,
              filetypes = { "javascript", "typescript" },
            })
          end,
        },
      }
    end,
  },

  -- {
  --   "nvimtools/none-ls.nvim",
  --   config = function()
  --     local null_ls = require("null-ls")
  --
  --     null_ls.setup({
  --       sources = {
  --         -- Setting untuk Blade Formatter yang mendukung .blade.php dan .html
  --         null_ls.builtins.formatting.blade_formatter.with({
  --           filetypes = { "blade", "html" }, -- Mendukung Blade dan HTML
  --         }),
  --         null_ls.builtins.formatting.prettier.with({
  --           filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  --         }),
  --
  --         -- Python formatters/linters
  --         null_ls.builtins.formatting.black.with({
  --           filetypes = { "python" },
  --         }),
  --         null_ls.builtins.formatting.isort.with({
  --           filetypes = { "python" },
  --         }),
  --
  --         -- null_ls.builtins.diagnostics.flake8.with({ --this for remember error on python
  --         --   filetypes = { "python" },
  --         -- }),
  --
  --         -- JSON formatter (Prettier)
  --         null_ls.builtins.formatting.prettier.with({
  --           filetypes = { "json", "jsonc" },
  --         }),
  --
  --         -- null_ls.builtins.formatting.sql_formatter.with({
  --         --   filetypes = { "sql", "up.sql" },
  --         -- }),
  --       },
  --     })
  --   end,
  -- },
}
