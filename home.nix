{ config, pkgs, ...}:

{
    home.username = "agar";
    home.homeDirectory = "/home/agar";
    home.stateVersion = "26.05";
    programs.bash = {
        enable = true;
        shellAliases = {
            buh = "fastfetch";
            switch = "sudo nixos-rebuild switch --flake .#goti-nixOS";
        };
       
    }; 
    programs.waybar = {
      enable = true;
    };
    home.packages = with pkgs; [
      vesktop
      feishin
    ];
}
