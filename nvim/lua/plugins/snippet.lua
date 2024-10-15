--return {
--  {
--    "nvim-cmp",
--    dependencies = { "hrsh7th/cmp-emoji" },
--    opts = function(_, opts)
--      table.insert(opts.sources, { name = "emoji" })
--    end,
--  },
--}

return {
  {
    "nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts)
      local cmp = require("cmp")
      -- Tambahkan sumber emoji
      -- table.insert(opts.sources, { name = "emoji" })

      -- Modifikasi mapping
      opts.mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
      })
      return opts
    end,
  },
}
