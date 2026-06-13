local map = vim.keymap.set

-- Esc 3 連打でハイライト消去
map("n", "<Esc><Esc><Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- telescope (denite の置き換え)
-- <C-z> (サスペンド→fg で復帰) と <C-c> (割込み/中断) はノーマルモード本来の
-- 挙動を残したいので leader 側へ移設。<C-p>/<C-n> は上下移動を潰すだけ
-- (挿入モードの補完は別物) かつ CtrlP 慣習に沿うのでそのまま。
map("n", "<C-p>", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })
map("n", "<C-n>", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>o", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>g", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })

-- neo-tree (defx の置き換え)
map("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
