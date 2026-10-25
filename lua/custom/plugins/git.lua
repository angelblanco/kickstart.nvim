-- Git review helpers: compare the current branch against develop / master.
-- Convention: lowercase = develop, uppercase = master.
--
-- Everything compares against the merge-base (the point where your branch
-- started), like GitHub's "Files changed" tab, and includes uncommitted edits.
-- Uses origin/<branch>, so run `git fetch` (or fetch in lazygit) to refresh.

-- diffview
-- https://github.com/sindrets/diffview.nvim
vim.pack.add { 'https://github.com/sindrets/diffview.nvim' }

require('diffview').setup {
  -- Icons come from mini.icons, only loaded with a nerd font
  use_icons = vim.g.have_nerd_font,
}

local function git_root() return vim.fs.root(0, '.git') or vim.fn.getcwd() end

--- Returns the merge-base between origin/<branch> and HEAD, or nil on error.
---@param branch string
---@return string?
local function merge_base(branch)
  local result = vim.system({ 'git', 'merge-base', 'origin/' .. branch, 'HEAD' }, { cwd = git_root(), text = true }):wait()
  if result.code ~= 0 then
    vim.notify(('No merge-base with origin/%s (missing branch or `git fetch` needed?)'):format(branch), vim.log.levels.ERROR)
    return nil
  end
  return vim.trim(result.stdout)
end

-- [[ Diffview: whole branch diff, toggles open/closed ]]
local function toggle_branch_diff(branch)
  if require('diffview.lib').get_current_view() then
    vim.cmd 'DiffviewClose'
    return
  end
  local base = merge_base(branch)
  if base then vim.cmd('DiffviewOpen ' .. base) end
end

vim.keymap.set('n', '<leader>gd', function() toggle_branch_diff 'develop' end, { desc = '[G]it [d]iff branch vs develop (toggle)' })
vim.keymap.set('n', '<leader>gD', function() toggle_branch_diff 'master' end, { desc = '[G]it [D]iff branch vs master (toggle)' })
vim.keymap.set('n', '<leader>gh', '<Cmd>DiffviewFileHistory %<CR>', { desc = '[G]it file [h]istory' })
vim.keymap.set('n', '<leader>gH', '<Cmd>DiffviewFileHistory<CR>', { desc = '[G]it branch [H]istory' })

-- [[ Telescope picker: files changed in the branch ]]
local function changed_files_picker(branch)
  local base = merge_base(branch)
  if not base then return end

  local root = git_root()
  -- --diff-filter=d skips deleted files, there is nothing to open
  local result = vim.system({ 'git', 'diff', '--name-only', '--diff-filter=d', base }, { cwd = root, text = true }):wait()
  local files = vim.split(vim.trim(result.stdout or ''), '\n', { trimempty = true })
  if #files == 0 then
    vim.notify(('No changes vs origin/%s'):format(branch), vim.log.levels.INFO)
    return
  end

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local make_entry = require 'telescope.make_entry'
  local conf = require('telescope.config').values
  local opts = { cwd = root }

  pickers
    .new(opts, {
      prompt_title = ('Changed vs origin/%s (%d)'):format(branch, #files),
      finder = finders.new_table { results = files, entry_maker = make_entry.gen_from_file(opts) },
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),
    })
    :find()
end

vim.keymap.set('n', '<leader>gf', function() changed_files_picker 'develop' end, { desc = '[G]it changed [f]iles vs develop' })
vim.keymap.set('n', '<leader>gF', function() changed_files_picker 'master' end, { desc = '[G]it changed [F]iles vs master' })

-- [[ Gitsigns base: cycle last commit -> develop -> master ]]
-- Not persisted: every new session starts comparing against the last commit.
-- With a branch base, ñc/Ñc jump through the branch changes and
-- <leader>hQ sends all of them to the quickfix list (then ñq/Ñq).
local gitsigns_bases = { false, 'develop', 'master' }
local gitsigns_base_index = 1

vim.keymap.set('n', '<leader>gb', function()
  local gitsigns = require 'gitsigns'
  -- Try the following bases in order, skipping branches this repo doesn't have
  for step = 1, #gitsigns_bases do
    local index = (gitsigns_base_index + step - 1) % #gitsigns_bases + 1
    local branch = gitsigns_bases[index]
    if not branch then
      gitsigns.reset_base(true)
      gitsigns_base_index = index
      vim.notify 'Gitsigns base: last commit'
      return
    end
    local base = merge_base(branch)
    if base then
      gitsigns.change_base(base, true)
      gitsigns_base_index = index
      vim.notify(('Gitsigns base: origin/%s'):format(branch))
      return
    end
  end
end, { desc = '[G]itsigns [b]ase: cycle commit/develop/master' })
