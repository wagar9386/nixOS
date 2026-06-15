{
  wayland.windowManager.hyprland = {
    enable = true;
  };

  xdg.configFile."hypr/hyprland.conf".source = 
    ./configs/hypr/hyprland.conf;
}
