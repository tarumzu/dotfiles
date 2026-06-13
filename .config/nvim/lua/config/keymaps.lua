local map = vim.keymap.set

-- Esc 3 連打でハイライト消去
map("n", "<Esc><Esc><Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- telescope: <C-z>(suspend)/<C-c>(中断) は潰さず leader へ。<C-p>/<C-n> は維持
map("n", "<C-p>", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<C-n>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>o", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>g", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })

-- neo-tree (defx の置き換え)
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
