{ config, pkgs, ... }:

{
    programs.rofi.enable = true;

    xdg.configFile."rofi/config.rasi".source = ../config/rofi/config.rasi;
}
