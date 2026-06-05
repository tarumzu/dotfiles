# dotfiles

## Setup

```sh
git clone git@github.com:tarumzu/dotfiles.git
cd dotfiles
./mac_setup.sh
```

On a fresh Mac the first `git` invocation triggers an Xcode Command
Line Tools install dialog — accept it. `mac_setup.sh` waits for the
install to finish, then prompts for `user.name` / `user.email` and
writes them to `~/.gitconfig_user` (kept out of this repo).
