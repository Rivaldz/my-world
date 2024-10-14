return {
  {
    "williamboman/mason.nvim",
    config = true, -- Use default config or customize
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "intelephense" }, -- Automatically install PHP language server
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
    end,
  },
}
