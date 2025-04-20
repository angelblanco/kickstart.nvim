return {
  'mikavilpas/yazi.nvim',
  event = 'VeryLazy',
  dependencies = {
    -- check the installation instructions at
    -- https://github.com/folke/snacks.nvim
    'folke/snacks.nvim',
  },
  keys = {
    -- 👇 in this section, choose your own keymappings!
    {
      '<leader>ex',
      mode = { 'n', 'v' },
      '<cmd>Yazi<cr>',
      desc = '[E][x]plore yazi at the current file',
    },
    {
      -- Open in the current working directory
      '<leader>ec',
      '<cmd>Yazi cwd<cr>',
      desc = "[E]xplore nvim's [C]wd with yazi",
    },
    {
      '<leader>er',
      '<cmd>Yazi toggle<cr>',
      desc = '[E]xplorer -> [R]esume the last yazi session',
    },
  },
  opts = {
    -- if you want to open yazi instead of netrw, see below for more info
    open_for_directories = true,
    keymaps = {
      show_help = '<f1>',
    },
  },
  -- 👇 if you use `open_for_directories=true`, this is recommended
  -- init = function()
  --   -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
  -- vim.g.loaded_netrw = 1
  --   vim.g.loaded_netrwPlugin = 1
  -- end,
}
