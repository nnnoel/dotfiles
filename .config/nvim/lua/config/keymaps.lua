-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Command mode using ; instead of :
vim.keymap.set("n", ";", ":", { noremap = true, silent = false })

-- Source refresh
vim.keymap.set("n", "<leader>sv", "<Cmd>so %<CR>", { noremap = true, silent = true, desc = "Source %" })

-- Tmux navigation
vim.keymap.set("n", "<C-h>", "<Cmd>TmuxNavigateLeft<CR>", { silent = true })
vim.keymap.set("n", "<C-j>", "<Cmd>TmuxNavigateDown<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", "<Cmd>TmuxNavigateUp<CR>", { silent = true })
vim.keymap.set("n", "<C-l>", "<Cmd>TmuxNavigateRight<CR>", { silent = true })

-- Resize window using <Alt> arrow keys
vim.keymap.set("n", "<M-Down>", "<Cmd>resize +2<CR>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<M-Up>", "<Cmd>resize -2<CR>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<M-Right>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<M-Left>", "<Cmd>vertical resize +2<CR>", { desc = "Increase Window Width" })

-- Open selection in GitHub
vim.keymap.set("v", "<leader>o", function()
  -- Use visual mode line range for GBrowse
  vim.cmd("'<,'>GBrowse")
end, { desc = "Open selection in GitHub" })
