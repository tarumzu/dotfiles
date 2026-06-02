-- leader は lazy ロード前に設定する必要がある
vim.g.mapleader = ","
vim.g.maplocalleader = ","

require("config.options")
require("config.keymaps")
require("config.lazy")
