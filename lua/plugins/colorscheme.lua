vim.pack.add { 'https://github.com/silentium-theme/silentium.nvim.git' }
local silentium = require 'silentium'
silentium.setup { accent = silentium.accents.yellow }
vim.cmd.colorscheme 'silentium'
vim.api.nvim_set_hl(0, 'StatusLine', { bg = silentium.colors.dark })
local diagnostic_error = vim.api.nvim_get_hl(0, { name = 'DiagnosticError', link = false })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = diagnostic_error.fg, fg = diagnostic_error.fg })
vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = silentium.colors.gray, italic = true })
vim.api.nvim_set_hl(0, 'Normal', { bg = silentium.colors.black })
