return {
  {
    "williamboman/mason.nvim",
    config = true, -- Use default config or customize
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "intelephense", "html", "lua_ls", "gopls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Setup LSP servers
      local lspconfig = require("lspconfig")

      lspconfig.intelephense.setup({
        -- Configure Intelephense (PHP Language Server)
        settings = {
          intelephense = {
            -- Add any specific settings for Intelephense here
            files = {
              maxSize = 5000000, -- Increase file size limit if needed
            },
          },
        },
      })

      lspconfig.cssls.setup({
        --Additional HTML-specific settings can be added here if needed
        filetypes = { "css", "scss" }, -- Add 'blade' to HTML filetypes
        settings = {
          css = { validate = true }, -- Aktifkan validasi CSS
          scss = { validate = true }, -- Aktifkan validasi SCSS
          less = { validate = false }, -- Opsional: dukungan untuk LESS
        },
      })

      -- Setup HTML LSP
      lspconfig.html.setup({
        --Additional HTML-specific settings can be added here if needed
        filetypes = { "blade", "html", "blade.html" }, -- Add 'blade' to HTML filetypes
        settings = {
          html = {
            format = {
              enable = false, -- Disable HTML formatting
            },
          },
        },
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false -- Disable formatting
          client.server_capabilities.documentRangeFormattingProvider = false -- Disable range formatting
        end,
      })

      -- Setup Lua LSP (lua_ls)
      lspconfig.lua_ls.setup({
        filetypes = { "lua" }, -- Add 'blade' to HTML filetypes
        -- settings = {
        --   Lua = {
        --     runtime = {
        --       version = 'LuaJIT', -- Use LuaJIT for Neovim
        --       path = vim.split(package.path, ";"),
        --     },
        --     diagnostics = {
        --       globals = { "vim" }, -- Recognize the 'vim' global
        --     },
        --     workspace = {
        --       library = vim.api.nvim_get_runtime_file("", true), -- Make LSP aware of Neovim runtime files
        --       checkThirdParty = false,                           -- Disable third-party library suggestions
        --     },
        --     telemetry = {
        --       enable = false, -- Disable telemetry to keep things light
        --     },
        --   },
        -- },
      })

      -- Setup Python LSP
      lspconfig.pyright.setup({
        -- Tambahkan pengaturan khusus untuk Pyright di sini, jika dibutuhkan
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
        filetypes = { "python" }, -- Menetapkan filetype ke 'python'
      })

      lspconfig.tsserver.setup({
        on_attach = function(client, bufnr)
          -- Disable tsserver's formatting capability to use another formatter like prettier
          client.server_capabilities.documentFormattingProvider = false

          -- Disable diagnostics for javascriptreact and typescriptreact
          if client.name == "tsserver" then
            client.server_capabilities.documentDiagnosticProvider = false
          end

          -- Keymaps for JavaScript/TypeScript features
          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        end,
        -- filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        filetypes = { "javascript", "typescript" },
      })

      -- Golang LSP (gopls)
      lspconfig.gopls.setup({
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
        on_attach = function(client, bufnr)
          local opts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        end,
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- Setting untuk Blade Formatter yang mendukung .blade.php dan .html
          null_ls.builtins.formatting.blade_formatter.with({
            filetypes = { "blade", "html" }, -- Mendukung Blade dan HTML
          }),
          null_ls.builtins.formatting.prettier.with({
            filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
          }),
        },
      })
    end,
  },
}
