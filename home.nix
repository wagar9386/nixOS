{ config, pkgs, ...}:

{
    home.username = "agar";
    home.homeDirectory = "/home/agar";
    home.stateVersion = "26.05";
    programs.bash = {
        enable = true;
        shellAliases = {
            buh = "fastfetch";
        };
        profileExtra = ''
                exec hyprland
        '';
    };
}
