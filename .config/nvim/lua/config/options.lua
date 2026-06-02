local opt = vim.opt

opt.history = 1000                      -- コマンド履歴
opt.clipboard:append("unnamedplus")     -- システムクリップボード共有
opt.autoindent = true
opt.hlsearch = true                     -- 検索結果のハイライト
opt.ignorecase = true                   -- smartcase の前提
opt.smartcase = true                    -- 大文字を含む検索は大/小を区別
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true                    -- タブを半角スペースに
opt.showmatch = true                    -- 対応する括弧を表示
opt.laststatus = 3                       -- グローバルステータスライン
opt.errorbells = false
opt.visualbell = true                   -- ビープではなく画面フラッシュ
opt.number = true                       -- 行番号
opt.cursorline = true
opt.termguicolors = true                -- truecolor (カラースキーム用)
opt.signcolumn = "yes"                   -- 行番号横のずれ防止 (gitsigns/診断)
opt.list = true
opt.listchars = { tab = ">-", trail = "~", nbsp = "-", extends = ">", precedes = "<" }
