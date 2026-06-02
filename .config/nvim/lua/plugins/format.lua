return {
  -- 整形 (旧 ale の整形機能の置き換え。lint は LSP 診断に委譲)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
      -- フォーマッタ未インストールなら LSP にフォールバック
      format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
    },
  },
}
