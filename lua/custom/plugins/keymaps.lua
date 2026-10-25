-- Spanish keyboard: `[` and `]` need AltGr, so use `ñ`/`Ñ` as aliases.
-- Like `n`/`N`: lowercase goes forward, uppercase goes back.
--   ñc / Ñc  next/prev git hunk
--   ñq / Ñq  next/prev quickfix item
--   ñd / Ñd  next/prev diagnostic
-- `remap = true` so every existing `]x`/`[x` mapping works through them.

vim.keymap.set({ 'n', 'x', 'o' }, 'ñ', ']', { remap = true, desc = 'Next (alias for ])' })
vim.keymap.set({ 'n', 'x', 'o' }, 'Ñ', '[', { remap = true, desc = 'Prev (alias for [)' })
