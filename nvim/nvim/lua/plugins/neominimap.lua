---@type LazySpec
return {
  {
    "Isrothy/neominimap.nvim",
    version = "v3.*.*",
    lazy = false,
    keys = {
      { "<leader>nm", "<cmd>Neominimap toggle<cr>", desc = "Toggle minimap" },
      { "<leader>nf", "<cmd>Neominimap toggleFocus<cr>", desc = "Toggle minimap focus" },
    },
    init = function()
      vim.opt.wrap = false
      vim.opt.sidescrolloff = 36
    end,
    opts = {
      auto_enable = true,
      exclude_filetypes = {
        "help",
        "bigfile",
        "neo-tree",
        "Trouble",
        "alpha",
        "dashboard",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
      },
    },
  },
}
