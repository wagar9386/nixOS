{ config, pkgs, ... }:

{
    home.packages = [
        (pkgs.beets.override {
            pluginOverrides = {
                fetchart.enable = true;
                embedart.enable = true;
                lastgenre.enable = true;
                lyrics.enable = true;
            };
        })
    ];

    xdg.configFile."beets/config.yaml".source = ../config/beets/config.yaml;
}
