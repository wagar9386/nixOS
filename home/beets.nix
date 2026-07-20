{ config, pkgs, ... }:

{
    xdg.configFile."beets/config.yaml".source = ../config/beets/config.yaml;
}
