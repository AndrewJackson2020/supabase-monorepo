require("config.lazy")

local clangd_opts = {}

 if not vim.lsp.is_enabled('clangd') then
     vim.lsp.enable('clangd', clangd_opts)
 end
