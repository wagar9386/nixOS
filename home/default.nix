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
    ];
    home.pointerCursor = {
    package = pkgs.capitaine-cursors-themed;
    name = "Capitaine Cursors (Gruvbox)";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    };
}
