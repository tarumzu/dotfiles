return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs",
    opts = {
      -- 旧構文プラグイン (Dockerfile.vim / vim-slim / vim-hashicorp-tools /
      -- vim-log-highlighting) はここで一括代替
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash",
        "ruby", "slim",
        "terraform", "hcl",
        "dockerfile",
        "json", "yaml", "toml", "markdown", "markdown_inline",
        "git_config", "gitcommit", "gitignore",
      },
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
    },
  },
}
