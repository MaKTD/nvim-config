return {
  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },
  -- session managment
  { "tpope/vim-obsession",   lazy = false },

  {
    "snacks.nvim",
    opts = {
      bigfile = {
        enabled = true,
        notify = true,          -- show notification when big file detected
        size = 3 * 1024 * 1024, -- 3MB
        line_length = 1000,     -- average line length (useful for minified files)
      },
      quickfile = { enabled = true },
    }
  },
}
