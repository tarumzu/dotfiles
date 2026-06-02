# dotfiles

## Prerequisites

Install the Xcode Command Line Tools (required to `git clone`):

```sh
xcode-select --install
```

## Setup

```sh
git clone git@github.com:tarumzu/dotfiles.git
cd dotfiles
./mac_setup.sh
```

The script will prompt for `user.name` / `user.email` and write
them to `~/.gitconfig_user` (kept out of this repo). Restart your
Mac when it finishes.
