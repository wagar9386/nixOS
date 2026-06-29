# ❄️ My nixOS dotfiles
*My NixOS configuration with Hyprland, Gruvbox, and a modular Home Manager setup. Feel free to look around and steal anything useful!*



![Desktop screenshot](assets/screenshot.png)

## Info
| | |
| **OS** | NixOS unstable |
| **WM** | Hyprland |
| **Terminal** | Kitty |
| **Shell** | Bash |
| **Bar** | Waybar |
| **Launcher** | Rofi |
| **Theme** | Gruvbox Dark |
| **Font** | JetBrainsMono Nerd Font |
| **Browser** | Firefox |
| **Editor** | Vim |

## Structure
```
nixos-dotfiles/
├── flake.nix                  # Entry point, pins nixpkgs + home-manager
├── configuration.nix          # System-level config (drivers, services, users)
├── hardware-configuration.nix # DO NOT COPY — machine specific
├── home/
│   ├── default.nix            # Home Manager root (packages, bash, imports)
│   ├── hyprland.nix           # Hyprland symlink declaration
│   ├── waybar.nix             # Waybar symlink declaration
│   └── kitty.nix              # Kitty symlink declaration
└── config/
    ├── hypr/
    │   ├── hyprland.lua       # Hyprland config (Gruvbox, keybinds, monitors)
    │   └── hyprpaper.conf     # Wallpaper config
    ├── waybar/
    │   ├── config.jsonc       # Waybar modules
    │   └── style.css          # Waybar Gruvbox theme
    └── kitty/
        ├── kitty.conf         # Kitty settings
        └── gruvbox.conf       # Kitty Gruvbox colors
```

## Commands
Rebuild and switch (from anywhere):
```bash
switch
```
Which expands to:
```bash
cd ~/nixos-dotfiles && sudo nixos-rebuild switch --flake .#goti-nixOS
```

Commit and push:
```bash
push "your commit message"
```

Update flake inputs (nixpkgs, home-manager):
```bash
nix flake update
switch
```

## Installation
Prerequisites: NixOS installed, flakes enabled.
> ⚠️ **Do NOT copy `hardware-configuration.nix`** — it's specific to my drives and will break your system.
```bash
git clone https://github.com/wagar9386/nixOS ~/nixos-dotfiles
cd ~/nixos-dotfiles
```

Generate your own hardware config:
```bash
sudo nixos-generate-config
cp /etc/nixos/hardware-configuration.nix ~/nixos-dotfiles/
```

Edit `flake.nix` and change `goti-nixOS` to your hostname, then:
```bash
sudo nixos-rebuild switch --flake .#yourHostname
```

## License
MIT — use or distribute freely.
