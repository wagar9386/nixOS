{ config, pkgs, ...}:

{
    home.username = "agar";
    home.homeDirectory = "/home/agar";
    home.stateVersion = "26.05";
    
    programs.bash = {
        enable = true;
        shellAliases = {
            buh = "fastfetch";
        };
        initExtra = ''
          switch() {
            cd /home/agar/nixos-dotfiles && sudo nixos-rebuild switch --flake .#goti-nixOS
          }
          
          push() {
            git add .
            git commit -m "''${1:-Update}"
            git push
          }
        '';
    }; 
    
    programs.waybar = {
        enable = true;
        settings = [
            {
                name = "mainBar";
                layer = "top";
                position = "top";
                height = 40;
                margin = "10px 10px 0px 10px";
                modules-left = [ "hyprland/workspaces" "hyprland/window" ];
                modules-center = [ "clock" ];
                modules-right = [ "battery" "network" "pulseaudio" "tray" ];
                
                "hyprland/workspaces" = {
                    format = "{icon}";
                    format-icons = {
                        "1" = "一";
                        "2" = "二";
                        "3" = "三";
                        "4" = "四";
                        "5" = "五";
                    };
                };
                
                "hyprland/window" = {
                    format = "{}";
                    max-length = 50;
                };
                
                "clock" = {
                    format = "🕐 {:%a %d %b  %H:%M}";
                    tooltip-format = "<big>{:%c}</big>";
                };
                
                "battery" = {
                    format = "{icon} {capacity}%";
                    format-icons = [ "🔋" "🔋" "🔋" "🔋" "⚡" ];
                };
                
                "network" = {
                    format-wifi = "📶 {essid} {signalStrength}%";
                    format-ethernet = "🌐 {ifname}";
                    format-disconnected = "❌ Offline";
                };
                
                "pulseaudio" = {
                    format = "{icon} {volume}%";
                    format-muted = "🔇";
                    format-icons = [ "🔉" "🔊" ];
                };
                
                "tray" = {
                    icon-size = 18;
                    spacing = 5;
                };
            }
        ];
        style = ''
          * {
            border: none;
            border-radius: 10px;
            font-family: "JetBrains Mono", "Font Awesome 6 Free";
            font-size: 14px;
            min-height: 0;
          }
          
          window#waybar {
            background: rgba(46, 52, 64, 0.9);
            color: #eceff4;
          }
          
          #workspaces button {
            background: transparent;
            padding: 5px 10px;
            color: #d8dee9;
            margin-right: 5px;
          }
          
          #workspaces button.active {
            background: #5e81ac;
            color: #eceff4;
            border-radius: 8px;
          }
          
          #workspaces button:hover {
            background: #434c5e;
            border-radius: 8px;
          }
          
          #window {
            background: rgba(67, 76, 94, 0.5);
            padding: 0 15px;
            border-radius: 8px;
            color: #a3be8c;
          }
          
          #clock {
            background: rgba(88, 166, 255, 0.1);
            color: #8fbcbb;
            padding: 0 20px;
            border-radius: 8px;
            font-weight: bold;
          }
          
          #battery {
            background: rgba(235, 203, 139, 0.1);
            color: #ebcb8b;
            padding: 0 12px;
            border-radius: 8px;
          }
          
          #network {
            background: rgba(163, 190, 140, 0.1);
            color: #a3be8c;
            padding: 0 12px;
            border-radius: 8px;
          }
          
          #pulseaudio {
            background: rgba(180, 142, 173, 0.1);
            color: #b48ead;
            padding: 0 12px;
            border-radius: 8px;
          }
          
          #tray {
            background: transparent;
          }
        '';
    };
    
    
    home.packages = with pkgs; [
        vesktop
        feishin
        jetbrains-mono
    ];
}
