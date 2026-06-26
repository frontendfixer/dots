require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- neo-tree (overrides NvChad nvim-tree bindings)
map("n", "<C-n>", "<cmd>Neotree toggle<CR>", { desc = "Toggle file tree" })
map("n", "<leader>e", "<cmd>Neotree focus<CR>", { desc = "Focus file tree" })
