{ config, pkgs, ... }:

{
    imports = [
        ./hyprland.nix
        ./waybar.nix
        ./kitty.nix
    ];

    home.username = "agar";
    home.homeDirectory = "/home/agar";
    home.stateVersion = "26.05";

    programs.bash = {
        enable = true;
        shellAliases = {
            buh = "fastfetch";
        };
        initExtra = ''
            PS1='\[\e[38;2;211;134;155m\]waga\[\e[0m\](\[\e[38;2;131;165;152m\]\W\[\e[0m\])\[\e[38;2;211;134;155m\]\$\[\e[0m\] ' 
          switch() {
            cd /home/agar/nixos-dotfiles && sudo nixos-rebuild switch --flake .#goti-nixOS
          }

          push() {
            git add .
            git commit -m "''${1:-Update}"
            git push
          }
        '';
    };

    home.packages = with pkgs; [
        vesktop
        feishin
        jetbrains-mono
        noto-fonts
        vimgolf
        nerd-fonts.jetbrains-mono
        capitaine-cursors-themed
        stremio-linux-shell
        steam
        pkgs.prismlauncher
        hyprshot
        exiftool
        (pkgs.retroarch.override {
           cores = with pkgs.libretro; [
               mupen64plus
           ];
        })
    ];
    home.pointerCursor = {
    package = pkgs.capitaine-cursors-themed;
    name = "Capitaine Cursors (Gruvbox)";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    };
}
