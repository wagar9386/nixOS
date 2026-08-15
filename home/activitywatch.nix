{ config, pkgs, ... }:

{
    home.packages = [ pkgs.activitywatch ];

    systemd.user.services.activitywatch = {
        Unit = {
            Description = "ActivityWatch time tracker";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
        };
        Service = {
            Type = "simple";
            ExecStart = "${pkgs.activitywatch}/bin/aw-server";
            Restart = "on-failure";
            RestartSec = 3;
        };
        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };

    systemd.user.services.activitywatch-watcher = {
        Unit = {
            Description = "ActivityWatch window watcher";
            After = [ "activitywatch.service" ];
            Requires = [ "activitywatch.service" ];
        };
        Service = {
            Type = "simple";
            ExecStart = "${pkgs.activitywatch}/bin/aw-watcher-window";
            Restart = "on-failure";
            RestartSec = 3;
        };
        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };

    systemd.user.services.activitywatch-afk = {
        Unit = {
            Description = "ActivityWatch AFK watcher";
            After = [ "activitywatch.service" ];
            Requires = [ "activitywatch.service" ];
        };
        Service = {
            Type = "simple";
            ExecStart = "${pkgs.activitywatch}/bin/aw-watcher-afk";
            Restart = "on-failure";
            RestartSec = 3;
        };
        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };
}
