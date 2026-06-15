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
    bashrcExtra = ''
      switch() {
        cd /home/agar/nixOS && sudo nixos-rebuild switch --flake .#goti-nixOS
      }
    '';
}; 
    programs.waybar = {
  enable = true;
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "hyprland/workspaces" ];
      modules-right = [ "clock" ];
    };
  };
  style = ''
    * {
      border: none;
      border-radius: 0;
      font-family: monospace;
      font-size: 13px;
      min-height: 0;
     }
    window#waybar {
      background: #282c34;
      color: #abb2bf;
      }
     '';
    };
    home.packages = with pkgs; [
      vesktop
      feishin
    ];
}
