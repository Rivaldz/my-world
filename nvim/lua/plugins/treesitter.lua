return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = { "go", "lua", "bash", "json"}, -- Add Go and other necessary languages
    highlight = {
      enable = true,                                    -- Enable Treesitter highlighting
      additional_vim_regex_highlighting = false,        -- Disable Vim regex highlighting
    },
    indent = {
      enable = true, -- Enable Treesitter-based indentation
    },
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   opts = function(_, opts)
  --     local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
  --     parser_config.blade = {
  --       install_info = {
  --         url = "https://github.com/EmranMR/tree-sitter-blade",
  --         files = { "src/parser.c" },
  --         branch = "main",
  --       },
  --       filetype = "blade, html",
  --     }
  --
  --     -- Memastikan 'blade' ada dalam daftar ensure_installed
  --     if type(opts.ensure_installed) == "table" then
  --       vim.list_extend(opts.ensure_installed, { "blade" })
  --     end
  --
  --     return opts
  --   end,
  -- },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   -- Menambahkan konfigurasi tambahan untuk mengatur filetype
  --   config = function(plugin, opts)
  --     require("nvim-treesitter.configs").setup(opts)
  --     vim.filetype.add({
  --       pattern = {
  --         [".*%.blade%.php"] = "blade",
  --       },
  --     })
  --   end,
  -- },
}
