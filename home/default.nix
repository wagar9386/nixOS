{
  imports = [
    ./packages.nix
    ./hyprland.nix
    ./waybar.nix
  ];

  home.stateVersion = "26.05"

  programs.home-manger.enable = true;
}
