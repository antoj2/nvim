vim.pack.add { 'https://github.com/vague-theme/vague.nvim.git' }
require('vague').setup {}
vim.cmd.colorscheme 'vague'

-- vim.pack.add { { src = 'https://github.com/Kaikacy/Lemons.nvim.git', version = vim.version.range '*' } }
-- vim.cmd.colorscheme 'lemons'

-- vim.pack.add { 'https://github.com/nendix/zen.nvim.git' }
-- vim.cmd.colorscheme 'zen'

-- vim.pack.add { 'https://github.com/blazkowolf/gruber-darker.nvim.git' }
-- vim.cmd.colorscheme 'gruber-darker'

-- vim.pack.add { 'https://github.com/nyoom-engineering/oxocarbon.nvim.git' }
-- vim.cmd.colorscheme 'oxocarbon'

-- vim.pack.add { 'https://github.com/mellow-theme/mellow.nvim' }
-- vim.cmd.colorscheme 'mellow'

-- vim.pack.add { 'https://github.com/dgox16/oldworld.nvim.git' }
-- vim.cmd.colorscheme 'oldworld'

vim.pack.add { 'https://github.com/zenbones-theme/zenbones.nvim.git', 'https://github.com/rktjmp/lush.nvim.git' }
vim.g.zenbones = { darkness = 'stark' }
vim.g.rosebones = { darkness = 'stark' }
vim.cmd.colorscheme 'zenbones'
