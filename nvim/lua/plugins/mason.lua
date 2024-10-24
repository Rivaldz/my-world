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

      -- Setup HTML LSP
      lspconfig.html.setup({
        --Additional HTML-specific settings can be added here if needed
        filetypes = { "html", "blade" }, -- Add 'blade' to HTML filetypes
      })

      -- Setup Lua LSP (lua_ls)
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT', -- Use LuaJIT for Neovim
              path = vim.split(package.path, ";"),
            },
            diagnostics = {
              globals = { "vim" }, -- Recognize the 'vim' global
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true), -- Make LSP aware of Neovim runtime files
              checkThirdParty = false,                           -- Disable third-party library suggestions
            },
            telemetry = {
              enable = false, -- Disable telemetry to keep things light
            },
          },
        },
      })
    end,
  },
}
