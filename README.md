# dotfiles

## Setup

```sh
git clone git@github.com:tarumzu/dotfiles.git
cd dotfiles
./mac_setup.sh
```

On a fresh Mac, Xcode Command Line Tools are installed first: a system
dialog appears — accept it, and the script waits for the install to
finish before continuing. It then prompts for `user.name` / `user.email`
and writes them to `~/.gitconfig_user` (kept out of this repo).

Re-runs are idempotent and show your current identity as the defaults.
Pass `-y` (or `--yes`) to skip the identity prompts and reuse the existing
values — handy for unattended re-runs:

```sh
./mac_setup.sh -y
```

## Per-machine extensions

For host-specific tooling that should not live in this repo, two
optional slots are loaded automatically when present:

| Slot | What it does |
|---|---|
| `Brewfile.local` (next to `Brewfile`) | Extra `brew bundle` entries for this host. |
| `~/.zsh/local.zsh` | Additional shell functions / env for this host. |

Both are gitignored. You can drop hand-written files into those paths
directly, or have `mac_setup.sh` populate them from a private overlay
repo by setting `DOTFILES_OVERLAY`:

```sh
DOTFILES_OVERLAY=git@github.com:<you>/<private-overlay>.git ./mac_setup.sh
```

The overlay repo is cloned to `~/.dotfiles-overlay/` and its
`Brewfile.local` / `zsh/local.zsh` are symlinked into the expected
paths. Subsequent runs `git pull --ff-only` the overlay.
