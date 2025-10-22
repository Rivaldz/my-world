return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    -- This downloads/builds the backend CLI
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup({
      sources = {
        -- Primary connection list
        require("dbee.sources").FileSource:new(vim.fn.expand("~/.config/dbee/connections.json")),

        -- Persistence (where Dbee auto-saves connections you add from UI)
        -- require("dbee.sources").FileSource:new(vim.fn.stdpath("cache") .. "/dbee/persistence.json"),

        -- Environment variable source (optional)
        require("dbee.sources").EnvSource:new("DBEE_CONNECTIONS"),
      },
      ui = {
        sidebar = { position = "right", width = 34 },
        result  = { split = "belowright", height = 14 },
      },
    })
  end,
}
