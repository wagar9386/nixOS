{ config, pkgs, ... }:

{
    imports = [
        ./hyprland.nix
        ./waybar.nix
        ./kitty.nix
        ./rofi.nix
        ./swappy.nix
        ./secrets.nix
    ];

    home.username = "agar";
    home.homeDirectory = "/home/agar";
    home.stateVersion = "26.05";

    programs.bash = {
        enable = true;
        shellAliases = {
            buh = "fastfetch";
            ls = "lsd";
        };
        initExtra = ''
            PS1='\[\e[38;2;211;134;155m\]waga\[\e[0m\](\[\e[38;2;131;165;152m\]\W\[\e[0m\])\[\e[38;2;211;134;155m\]\$\[\e[0m\] ' 
          switch() {
            cd /home/agar/nixos-dotfiles && sudo nixos-rebuild switch --flake .#goti-nixOS
          }

          push() {
            git pull
            git add .
            git commit -m "''${1:-Update}"
            git push
          }
        '';
    };

    home.packages = with pkgs; [
        vesktop
        playerctl
        pavucontrol
        feishin
        noto-fonts
        vimgolf
        nerd-fonts.jetbrains-mono
        capitaine-cursors-themed
        stremio-linux-shell
        lsd
        steam
        ranger
        ueberzugpp
        prismlauncher
        flameshot
        grim
        slurp
        swappy
        exiftool
        wl-clipboard
        cifs-utils
        hyprlock
        xdg-utils
        pcmanfm
        (pkgs.writeShellScriptBin "deemix" ''
        nix run github:bambanah/deemix#webui &
        sleep 2
        firefox http://localhost:6595
        '')
        (pkgs.retroarch.withCores (cores: with cores; [
            mupen64plus
        ]))
        ];
    xdg.configFile."hypr/hyprlock.conf".source = ../config/hypr/hyprlock.conf;
    home.pointerCursor = {
    enable = true;
    package = pkgs.capitaine-cursors-themed;
    name = "Capitaine Cursors (Gruvbox)";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
    };
    home.file."Pictures/screenies/.keep".text = "";
    xdg.userDirs = {
    enable = true;
    createDirectories = true;
    download = "${config.home.homeDirectory}/Downloads";
    pictures = "${config.home.homeDirectory}/Pictures";
    music = "${config.home.homeDirectory}/Music";
    videos = "${config.home.homeDirectory}/Videos";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = "${config.home.homeDirectory}/Desktop";
    templates = "${config.home.homeDirectory}/Templates";
    publicShare = "${config.home.homeDirectory}/Public";
};
}
