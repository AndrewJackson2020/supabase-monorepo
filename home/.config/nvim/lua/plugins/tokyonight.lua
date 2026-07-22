return {
  "folke/tokyonight.nvim",
  lazy = false, -- Load immediately at startup
  priority = 1000, -- Make sure it loads before other plugins
  opts = {
    style = "night", -- Choose from "storm", "night", "day", or "moon"
    transparent = true, -- Set true to enable transparent background
    terminal_colors = true, -- Configure terminal colors
  },
  config = function(_, opts)
    require("tokyonight").setup(opts)
    vim.cmd("colorscheme tokyonight-night") -- Apply the exact night theme
  end,
}
