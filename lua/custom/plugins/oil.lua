-- oil
-- https://github.com/stevearc/oil.nvim
--
-- Edit the filesystem like a normal buffer: rename with `cw`, delete with `dd`,
-- create files/dirs by typing a new line (end with `/` for a dir), then `:w`.
-- `-` goes to the parent directory, `<CR>` opens, `g?` shows help.

vim.pack.add { 'https://github.com/stevearc/oil.nvim' }

require('oil').setup {
  -- Also replaces netrw, so `nvim .` opens oil
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
  },
}

vim.keymap.set('n', '-', '<Cmd>Oil<CR>', { desc = 'Open parent directory (oil)' })
