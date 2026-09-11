# dotfiles

My Linux config: bash, git, Ghostty, Oh My Posh (takuya theme), and Claude Code settings.

## Setup on a new machine

```bash
# Oh My Posh first
curl -s https://ohmyposh.dev/install.sh | bash -s

git clone https://github.com/GhouI/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` symlinks each file into `$HOME` (backing up anything already there as `.bak`) and installs the Meslo Nerd Font if it's missing. Restart the terminal afterwards.

## Adding a new file

Move it into `~/dotfiles` at the same path relative to `$HOME`, add that path to `LINKS` in `install.sh`, and re-run it.

## Not tracked

Secrets and machine state stay out of the repo: `~/.claude/.credentials.json`, `~/.claude.json`, Claude history/projects, `~/.ssh`, `~/.gnupg`, `~/.config/gh`.
