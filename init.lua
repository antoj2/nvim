require 'options'
require 'plugins.colorscheme'

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<Leader>e', function()
  vim.diagnostic.open_float()
end)

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.pack.add { 'https://github.com/NMAC427/guess-indent.nvim.git' }
require('guess-indent').setup {}

vim.pack.add { 'https://github.com/j-hui/fidget.nvim.git' }
require('fidget').setup {
  notification = {
    poll_rate = 7,
  },
}

vim.pack.add { 'https://github.com/neovim/nvim-lspconfig' }
vim.lsp.enable { 'lua_ls', 'rust_analyzer', 'bashls', 'basedpyright', 'ts_ls' }

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end

    vim.keymap.set({ 'i', 'n' }, '<M-R>', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { nil })
    end, { desc = 'Toggle Inlay Hints' })
  end,
})

vim.pack.add { { src = 'https://github.com/saghen/blink.cmp.git', version = vim.version.range '*' } }
require('blink.cmp').setup {
  completion = {
    menu = { border = 'none' },
    documentation = { auto_show = true, auto_show_delay_ms = 0 },
    ghost_text = { enabled = true },
  },
  sources = {
    default = { 'lsp', 'buffer', 'path', 'cmdline' },
  },
  keymap = {
    preset = 'enter',
  },
}

vim.pack.add { 'https://github.com/zbirenbaum/copilot.lua.git' }
require('copilot').setup {
  suggestion = {
    auto_trigger = true,
    keymap = {
      accept = '<Tab>',
      next = '<M-Right>',
      prev = '<M-Left>',
    },
  },
}

vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim.git' }
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

vim.pack.add { 'https://github.com/nvim-mini/mini.icons.git' }
require('mini.icons').setup()

vim.pack.add { 'https://github.com/stevearc/oil.nvim.git' }
require('oil').setup {
  columns = {
    'icon',
    'size',
  },
  delete_to_trash = true,
}
vim.keymap.set('n', '<leader>io', '<CMD>Oil --float<CR>', { desc = 'Open Oil' })

vim.pack.add { 'https://github.com/ibhagwan/fzf-lua.git' }
local fzf = require 'fzf-lua'
fzf.setup {}
local map = vim.keymap.set
map('n', '<leader>sk', fzf.keymaps, { desc = 'Search keymaps' })
map('n', '<leader>ss', fzf.live_grep, { desc = 'Live grep current project' })
map('n', '<leader>sc', fzf.lgrep_curbuf, { desc = 'Live grep current buffer' })
map('n', '<leader><leader>', fzf.buffers, { desc = 'Open buffers' })
map('n', '<leader>sr', fzf.oldfiles, { desc = 'Recent files' })
map('n', '<C-P>', fzf.lsp_document_symbols, { desc = 'Search LSP symbols' })
map('n', '<leader>sf', fzf.files, { desc = 'Project files' })
map('n', 'gd', fzf.lsp_definitions, { desc = 'LSP definitions' })
map('n', 'gD', fzf.lsp_declarations, { desc = 'LSP declarations' })
map('n', 'grr', fzf.lsp_references, { desc = 'LSP references' })
map('n', 'gi', fzf.lsp_implementations, { desc = 'LSP implementations' })
map('n', 'gcd', fzf.diagnostics_workspace, { desc = 'Workspace diagnostics' })
map('n', '<leader>sbl', fzf.builtin, { desc = 'Fzf-lua builtins' })
map('n', '<leader>man', fzf.manpages, { desc = 'Manpages' })
map('n', '<leader>sh', fzf.helptags, { desc = 'Search helptags' })

vim.pack.add { 'https://github.com/nvim-mini/mini.ai.git' }
require('mini.ai').setup()
vim.pack.add { 'https://github.com/nvim-mini/mini.surround.git' }
require('mini.surround').setup()

vim.pack.add { 'https://github.com/nvim-lualine/lualine.nvim' }
require('lualine').setup {
  options = { theme = 'auto', component_separators = '|', section_separators = '' },
  sections = {
    lualine_a = {
      {
        'mode',
        fmt = function(str)
          return string.sub(str, 1, 1)
        end,
      },
    },
    lualine_c = {
      { 'filename', path = 1 },
    },

    lualine_x = { 'encoding', 'filetype' },
  },
}

vim.pack.add { 'https://github.com/stevearc/conform.nvim.git' }
require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true }
    return {
      timeout_ms = 2500,
      lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
    }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    typst = { 'typstyle' },
    python = { 'ruff_format', 'black' },
  },
}
vim.keymap.set('n', '<leader>f', function()
  require('conform').format { async = true, lsp_fallback = true }
end, { desc = 'Format file' })

vim.pack.add { 'https://github.com/folke/which-key.nvim.git' }
require('which-key').setup {}
