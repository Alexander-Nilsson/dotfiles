-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- maping $ to ¤
vim.api.nvim_set_keymap("n", "¤", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "¤", "$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("o", "¤", "$", { noremap = true, silent = true })
