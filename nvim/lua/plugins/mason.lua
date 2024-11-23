return {
  {
    "williamboman/mason.nvim",
    config = true, -- Use default config or customize
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "intelephense", "html", "lua_ls" },
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
        filetypes = { "css", "scss"}, -- Add 'blade' to HTML filetypes
        settings = {
          css = { validate = true },   -- Aktifkan validasi CSS
          scss = { validate = true },  -- Aktifkan validasi SCSS
          less = { validate = true }   -- Opsional: dukungan untuk LESS
        }
      })

      -- Setup HTML LSP
      lspconfig.html.setup({
        --Additional HTML-specific settings can be added here if needed
        filetypes = { "blade", "html" }, -- Add 'blade' to HTML filetypes
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
            filetypes = { "blade" }, -- Mendukung Blade dan HTML
          }),
        },
      })
    end,
  }
}
