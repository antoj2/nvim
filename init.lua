_G.is_mac = vim.loop.os_uname().sysname == 'Darwin'

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
vim.lsp.enable { 'lua_ls', 'rust_analyzer', 'bashls', 'basedpyright' }

if is_mac then
  vim.lsp.enable { 'ts_ls', 'emmet_language_server' }
end

local last_current_line = false

-- toggle current line only
vim.keymap.set('n', '<M-e>', function()
  local vl = vim.diagnostic.config().virtual_lines
  if type(vl) == 'table' and vl.current_line then
    vim.diagnostic.config { virtual_lines = false }
    last_current_line = true
  else
    vim.diagnostic.config { virtual_lines = { current_line = true } }
    last_current_line = true
  end
end, { desc = 'Toggle virtual lines for current line' })

-- toggle all lines with memory
vim.keymap.set('n', '<M-E>', function()
  local vl = vim.diagnostic.config().virtual_lines
  if vl == true then
    if last_current_line then
      vim.diagnostic.config { virtual_lines = { current_line = true } }
    else
      vim.diagnostic.config { virtual_lines = false }
    end
  else
    last_current_line = (type(vl) == 'table' and vl.current_line) or false
    vim.diagnostic.config { virtual_lines = true }
  end
end, { desc = 'Toggle virtual lines globally with memory' })

-- Java
vim.pack.add {
  {
    src = 'https://github.com/JavaHello/spring-boot.nvim',
    version = '218c0c26c14d99feca778e4d13f5ec3e8b1b60f0',
  },
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/mfussenegger/nvim-dap',

  'https://github.com/nvim-java/nvim-java',
}

require('java').setup {
  jdk = {
    auto_install = false,
  },

  lombok = {
    enable = false,
  },

  java_test = {
    enable = false,
  },

  java_debug_adapter = {
    enable = false,
  },

  spring_boot_tools = {
    enable = false,
  },
}
vim.lsp.enable 'jdtls'

-- Pico-8
if is_mac then
  vim.filetype.add {
    extension = {
      p8 = 'p8',
    },
  }

  vim.treesitter.language.register('pico8', 'p8')

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { '*.p8' },
    callback = function()
      vim.bo.commentstring = '-- %s'
    end,
  })
  vim.lsp.enable 'pico8_ls'
end

if is_mac then
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'kitty',
    callback = function()
      vim.bo.commentstring = '# %s'
    end,
  })
end

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

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name ~= 'blink.cmp' then
      return
    end

    vim.notify('Building blink.cmp', vim.log.levels.INFO)

    vim.fn.jobstart({ 'cargo', 'build', '--release' }, {
      cwd = ev.data.path,
      on_stdout = function(_, data)
        for _, line in ipairs(data) do
          if line ~= '' then
            vim.notify('[blink.cmp] ' .. line, vim.log.levels.INFO)
          end
        end
      end,
      on_stderr = function(_, data)
        for _, line in ipairs(data) do
          if line ~= '' then
            vim.notify('[blink.cmp] ' .. line, vim.log.levels.INFO)
          end
        end
      end,
      on_exit = function(_, code)
        if code == 0 then
          vim.notify('blink.cmp build finished successfully', vim.log.levels.INFO)
        else
          vim.notify(('blink.cmp build failed (exit code %d)'):format(code), vim.log.levels.ERROR)
        end
      end,
      stdout_buffered = false,
      stderr_buffered = false,
    })
  end,
})

vim.pack.add { 'https://github.com/saghen/blink.cmp.git' }
require('blink.cmp').setup {
  completion = {
    menu = { border = 'none' },
    documentation = { auto_show = true, auto_show_delay_ms = 0 },
    ghost_text = { enabled = false },
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
map('n', '<leader>sb', fzf.builtin, { desc = 'Fzf-lua builtins' })
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
    local disable_filetypes = { c = true, p8 = true }
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
