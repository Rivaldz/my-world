return {
  {
    "nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')

      -- Change mapping
      opts.mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
      })

      -- Add event confirm_done for auto-pairs
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )

      return opts
    end,
  }
}
