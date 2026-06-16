{ config, pkgs, ... }:

{
    programs.waybar.enable = true;

    xdg.configFile."waybar/config.jsonc".source = ../config/waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ../config/waybar/style.css;

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
        };
        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };
}
