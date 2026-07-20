{ config, pkgs, ... }:

{
    home.packages = [
        (pkgs.beets.override {
            extras = true;
        })
    ];

    xdg.configFile."beets/config.yaml".source = ../config/beets/config.yaml;
}
