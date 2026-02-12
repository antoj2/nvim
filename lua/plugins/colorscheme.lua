-- vim.pack.add { 'https://github.com/vague-theme/vague.nvim.git' }
-- require('vague').setup {}
-- vim.cmd.colorscheme 'vague'

-- vim.pack.add { { src = 'https://github.com/Kaikacy/Lemons.nvim.git', version = vim.version.range '*' } }
-- vim.cmd.colorscheme 'lemons'

-- vim.pack.add { 'https://github.com/nendix/zen.nvim.git' }
-- vim.cmd.colorscheme 'zen'

-- vim.pack.add { 'https://github.com/blazkowolf/gruber-darker.nvim.git' }
-- vim.cmd.colorscheme 'gruber-darker'

-- vim.pack.add { 'https://github.com/nyoom-engineering/oxocarbon.nvim.git' }
-- vim.cmd.colorscheme 'oxocarbon'

-- vim.pack.add { 'https://github.com/mellow-theme/mellow.nvim.git' }
-- vim.cmd.colorscheme 'mellow'

-- vim.pack.add { 'https://github.com/dgox16/oldworld.nvim.git' }
-- vim.cmd.colorscheme 'oldworld'

if not _G.is_mac then
  vim.pack.add { { src = 'https://github.com/catppuccin/nvim.git', name = 'catppuccin' } }
  require('catppuccin').setup {
    flavour = 'mocha',
    color_overrides = {
      mocha = {
        base = '#000000',
        mantle = '#000000',
        crust = '#000000',
      },
    },
  }
  vim.cmd.colorscheme 'catppuccin'
end

if _G.is_mac then
  vim.pack.add { 'https://github.com/silentium-theme/silentium.nvim.git' }
  local silentium = require 'silentium'
  silentium.setup { accent = silentium.accents.pink }
  vim.cmd.colorscheme 'silentium'
  local theme = require 'lualine.themes.auto'
  theme.normal.c = { bg = silentium.colors.dark, fg = silentium.colors.light_gray }
  theme.insert.c = { bg = silentium.colors.dark, fg = silentium.colors.light_gray }
  theme.visual.c = { bg = silentium.colors.dark, fg = silentium.colors.light_gray }
  theme.replace.c = { bg = silentium.colors.dark, fg = silentium.colors.light_gray }
  theme.command.c = { bg = silentium.colors.dark, fg = silentium.colors.light_gray }
  require('lualine').setup {
    options = {
      theme = theme,
    },
  }
  local diagnostic_error = vim.api.nvim_get_hl(0, { name = 'DiagnosticError', link = false })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = diagnostic_error.fg, fg = diagnostic_error.fg })
  vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = silentium.colors.gray, italic = true })
end
