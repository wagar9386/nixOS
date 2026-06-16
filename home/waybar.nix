{ config, pkgs, ... }:

let
  # Create a custom python environment with all dependencies needed for the scripts
  mediaPythonEnv = pkgs.python3.withPackages (ps: [
    ps.pillow               # For image resizing in the popup
    ps.tkinter              # For the popup window UI
    ps.pygobject3           # To listen to Playerctl via DBus
  ]);
in
{
  programs.waybar.enable = true;

  # Symlink your configurations
  xdg.configFile."waybar/config.jsonc".source = ../config/waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ../config/waybar/style.css;
  
  # Symlink the entire scripts directory into ~/.config/waybar/scripts/
  xdg.configFile."waybar/scripts".source = ../config/waybar/scripts;

  # Make sure playerctl CLI utility is installed for the system
  home.packages = [ pkgs.playerctl ];

  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar status bar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
      RestartSec = 1;
      
      Environment = [
        "PATH=${mediaPythonEnv}/bin:${pkgs.playerctl}/bin:\${PATH}"
        "GI_TYPELIB_PATH=${pkgs.playerctl}/lib/girepository-1.0:${pkgs.gtk3}/lib/girepository-1.0"
      ];
    }; # <-- This closes Service properly!

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
