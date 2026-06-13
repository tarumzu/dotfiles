# CLAUDE.md

Personal macOS dotfiles. Symlink-based: `mac_setup.sh` links tracked files
into `$HOME` (and `$HOME/.config`), installs Homebrew packages from `Brewfile`,
and applies macOS `defaults`.

## Conventions

- **Commit messages and PR titles/bodies are written in English**, even when
  the working conversation is in Japanese. This includes automated PRs
  (see `.github/workflows/update-nvim-plugins.yml`).
- In-repo **comments are Japanese** (existing style) — match it when editing.
- 2-space indent, LF, UTF-8, final newline (`.editorconfig`).

## Layout

- `mac_setup.sh` — idempotent setup. Resolves repo root via `$SCRIPT_DIR`
  (works from any CWD); re-running should be a no-op where nothing changed.
- `.zshrc` → sources `.zsh/*.zsh` modules (`options`, `aliases`, `tools`,
  `keybinds`, `prompt`), then `~/.zsh/local.zsh` if present.
- `.config/` — XDG configs (nvim, sheldon, starship, ghostty, git, atuin),
  symlinked as whole dirs/files by `CONFIG_LINKS` in `mac_setup.sh`.

## Machine-specific / private data — keep OUT of this repo

This is a **public** repo. Never commit machine-specific paths or
profile-specific tool usage. Three escape hatches exist:

- `~/.gitconfig_user` — `user.name` / `user.email` (written by setup, gitignored).
- `~/.gitconfig_signing` — optional SSH/GPG signing config (include is a no-op
  when absent).
- **Overlay**: `DOTFILES_OVERLAY=<git url> ./mac_setup.sh` clones a private repo
  to `~/.dotfiles-overlay/` and links its `Brewfile.local` and `zsh/local.zsh`;
  its `setup.sh` (if executable) runs for host-specific setup. Per-host
  `Brewfile.local` and `~/.zsh/local.zsh` are gitignored.

## Dependency pinning (supply-chain hygiene)

- `.config/sheldon/plugins.toml` — plugins pinned to a specific `rev`. Bump
  only after reviewing the upstream diff. The `# branch:` line is read by
  Renovate's customManager (`renovate.json`); keep it in sync.
- `.config/nvim/lazy-lock.json` — pinned by the weekly `update-nvim-plugins`
  workflow (Renovate can't manage it). Review the diff before merging.

## CI (all under `.github/workflows/`, actions pinned by SHA)

- `shellcheck` — every tracked `*.sh`.
- `zsh-syntax` — `zsh -n` over `.zshrc` and `*.zsh`.
- `brewfile` — verifies each tap/formula/cask resolves.
- `renovate-config` — validates `renovate.json`.

Before committing shell changes, mirror CI locally: `shellcheck mac_setup.sh`
and `zsh -n .zshrc .zsh/*.zsh`.
