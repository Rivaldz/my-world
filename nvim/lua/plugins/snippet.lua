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

      table.insert(opts.sources, { name = "emoji" })

      opts.mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
      })
      return opts
    end,
  },
}
