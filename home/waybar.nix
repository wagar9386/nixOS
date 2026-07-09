{ config, pkgs, ... }:

let
  # Custom python environment with the required C-binding wrappers
  mediaPythonEnv = pkgs.python3.withPackages (ps: [
    ps.pillow               
    ps.tkinter              
    ps.pygobject3           
  ]);

  # Create an absolute path executable wrapper script
  mediaScript = pkgs.writeShellScript "waybar-mediaplayer" ''
    export PATH="${pkgs.playerctl}/bin:$PATH"
    export GI_TYPELIB_PATH="${pkgs.playerctl}/lib/girepository-1.0:${pkgs.gtk3}/lib/girepository-1.0"
    exec ${mediaPythonEnv}/bin/python3 ${config.xdg.configHome}/waybar/scripts/mediaplayer.py
  '';
in
{
  programs.waybar = {
    enable = true;
  };
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
  # Symlink style and scripts
  xdg.configFile."waybar/style.css".source = ../config/waybar/style.css;
  xdg.configFile."waybar/scripts".source = ../config/waybar/scripts;

  # Let Home Manager manage config.jsonc directly so we can pass it the raw executable path
  xdg.configFile."waybar/config.jsonc".text = builtins.toJSON (
    (builtins.fromJSON (builtins.readFile ../config/waybar/config.jsonc)) // {
      "custom/media" = (builtins.fromJSON (builtins.readFile ../config/waybar/config.jsonc))."custom/media" // {
        # This replaces whatever "exec" you wrote with the bulletproof absolute Nix store path script
        "exec" = "${mediaScript} 2> /dev/null";
      };
    }
  );

  home.packages = [ pkgs.playerctl ];

}
