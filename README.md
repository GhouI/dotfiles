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

## Hyprland rice (Catppuccin Mocha)

Configs: `.config/hypr`, `waybar`, `rofi`, `mako`, `fastfetch`. **Not yet tested on a live Hyprland session.**

### Finish setting it up

1. Install packages:
   ```bash
   sudo apt install -y hyprland hyprlock hypridle hyprpaper hyprpolkitagent xdg-desktop-portal-hyprland waybar rofi mako-notifier fastfetch wl-clipboard cliphist grim slurp brightnessctl playerctl pavucontrol nwg-look qt6ct btop cava network-manager-gnome blueman wlogout papirus-icon-theme
   ```
2. Check the config before logging in — fix any line it complains about (see https://wiki.hypr.land):
   ```bash
   Hyprland --verify-config
   ```
   The `windowrule` / `layerrule` lines at the bottom of `hyprland.conf` are the most likely to need tweaking. Worst case, delete them — everything else still works.
3. Log out, click the gear icon on the login screen, pick **Hyprland**, log in. GNOME is still there if anything goes wrong.
4. If the wallpaper doesn't show, check `hyprpaper` in a terminal for errors in `hyprpaper.conf`.

### Keys (Super = Windows key)

| Keys | Action |
|---|---|
| Super + Enter | Terminal |
| Super + Space | App launcher |
| Super + Q | Close window |
| Super + 1–9 / Shift+1–9 | Switch / move to workspace |
| Super + arrows | Move focus |
| Super + V | Clipboard history |
| Super + L | Lock |
| Print / Shift+Print | Screenshot region / full |
| Super + Shift + E | Power menu |
| Super + Shift + R | Restart the bar |

### Make it anime

- Wallpaper: replace `~/Pictures/wallpapers/wallpaper.png` (wallhaven.cc → filter Anime, 2560×1440).
- fastfetch: put a transparent PNG at `~/.config/fastfetch/logo.png`.
