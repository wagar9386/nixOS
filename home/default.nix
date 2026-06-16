{ config, pkgs, ... }:

{
    imports = [
        ./hyprland.nix
        ./waybar.nix
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
    ];
}
