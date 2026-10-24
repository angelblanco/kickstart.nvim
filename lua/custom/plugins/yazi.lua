-- yazi
-- https://github.com/mikavilpas/yazi.nvim

vim.pack.add {
  -- check the installation instructions at
  -- https://github.com/folke/snacks.nvim
  'https://github.com/folke/snacks.nvim',
  'https://github.com/mikavilpas/yazi.nvim',
}

require('yazi').setup {
  -- if you want to open yazi instead of netrw, see below for more info
  open_for_directories = false,
  keymaps = {
    show_help = '<f1>',
  },
}

-- 👇 if you use `open_for_directories=true`, this is recommended
-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

-- 👇 in this section, choose your own keymappings!
vim.keymap.set({ 'n', 'v' }, '<leader>ex', '<cmd>Yazi<cr>', { desc = '[E][x]plore yazi at the current file' })
-- Open in the current working directory
vim.keymap.set('n', '<leader>ec', '<cmd>Yazi cwd<cr>', { desc = "[E]xplore nvim's [C]wd with yazi" })
vim.keymap.set('n', '<leader>er', '<cmd>Yazi toggle<cr>', { desc = '[E]xplorer -> [R]esume the last yazi session' })
