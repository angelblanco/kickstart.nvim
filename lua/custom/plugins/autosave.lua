-- auto-save
-- https://github.com/okuuva/auto-save.nvim

vim.pack.add { { src = 'https://github.com/okuuva/auto-save.nvim', version = vim.version.range '*' } }
require('auto-save').setup {
  -- default config by default
}

vim.keymap.set('n', '<leader>ts', '<cmd>ASToggle<CR>', { desc = '[T]oggle Auto-[S]ave' })
