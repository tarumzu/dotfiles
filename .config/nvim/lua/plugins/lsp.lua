return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local servers = { "lua_ls", "bashls" }

      -- blink.cmp の補完 capabilities を全サーバへ適用
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- lua_ls: vim グローバルを既知にして警告を抑制
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      -- mason で自動インストールし、インストール済みサーバを自動有効化
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = true,
      })

      -- LSP アタッチ時のキーマップ
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local function bufmap(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
          end
          bufmap("gd", vim.lsp.buf.definition, "Goto definition")
          bufmap("gr", vim.lsp.buf.references, "References")
          bufmap("K", vim.lsp.buf.hover, "Hover")
          bufmap("<leader>rn", vim.lsp.buf.rename, "Rename")
          bufmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
          bufmap("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
          bufmap("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
        end,
      })
    end,
  },
}
