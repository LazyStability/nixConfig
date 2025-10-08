{ lib, ... }:
{
  stylix.targets.waybar = {
    addCss = false;
  };
  programs.waybar = {
    style = lib.mkAfter ''

      window#waybar {
          background: rgba(0,0,0,0);
          color: white;
      }

      tooltip {
        background: rgba(43, 48, 59, 0.5);
        border: 1px solid rgba(100, 114, 125, 0.5);
      }
      tooltip label {
        color: white;
      }

      #mode, #clock, #battery {
          padding: 0 10px;
      }

      #mode {
          background: #64727D;
          border-bottom: 3px solid white;
      }
      #cpu {
          padding: 0 5px;
          background-color: @base00;
      }
      #memory {
          padding: 0 5px;
          background-color: @base00;
      }
      #bluetooth{
          background-color: @base00;
          padding: 0 5px;
          border-radius: 0 10px 10px 0;
      }
      #privacy{
          background-color: @base00;
          padding: 10px 10px;
          border-radius: 10px 10px 10px 10px;
      }

      #clock {
          background-color: @base00;
          padding: 0 5px;
          border-radius: 10px 10px 10px 10px;
      }
      #mpd {
          background-color: @base00;
          padding: 0 5px;
          border-radius: 10px 0 0 10px;
      }
      #temperature {
          background-color: @base00;
          padding: 0 5px;
          border-radius: 10px 0 0 10px;
      }
      #battery {
          background-color: @base00;
          color: white;
          padding: 0 5px;
          border-radius: 10px 10px 10px 10px;
      }

      #battery.charging {
          color: white;
          background-color: @base00;
          padding: 0 5px;
      }

      @keyframes blink {
          to {
              background-color: transparent;
              color: black;
          }
      }

      #battery.warning:not(.charging) {
          background: #f53c3c;
          color: white;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: steps(12);
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }
      #network{

          background-color: @base00;
          padding: 0 5px;
          border-radius: 0 10px 10px 0;
      }
      #submap{
          background-color: @base00;
          padding: 10px 10px;
          border-radius: 10px 10px 10px 10px;
      }

    '';

    ##############
    ## Settings ##
    ##############
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        modules-left = [
          "cpu"
          "memory"
          "bluetooth"
          "privacy"
          "hyprland/submap"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "mpd"
          "battery"
          "temperature"
          "network"
        ];
        clock = {
          format = "{:%H:%M}";
          interval = 60;
          tooltip = true;
          tooltip-format = "{:%Y-%m-%d}";
        };
        bluetooth = {
          format = "<span color='#00BFFF'>  </span>{status} ";
          format-connected = "<span color='#00BFFF'>  </span> {num_connections}";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };
        cpu = {
          format = "{usage}% ";
        };
        memory = {
          format = "{}% ";
        };
        temperature = {
          thermal-zone = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format-critical = "{temperatureC}°C {icon}";
          format = "{temperatureC}°C {icon}";
          format-icons = [
            ""
            ""
            ""
          ];
        };
        mpd = {
          consume-icons = {
            on = " ";
          };
          format = "{stateIcon} ({elapsedTime:%M:%S}/{totalTime:%M:%S})";
          format-stopped = "";
          format-disconnected = "";
          interval = 10;
          random-icons = {
            off = "<span color=\"#f53c3c\"></span> ";
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip = true;
          tooltip-format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ";
        };
        battery = {
          format = "{icon} {capacity}%";
          format-alt = "{time} {icon}";
          format-charging = " {capacity}%";
          format-icons = [
            "󰂎"
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format-plugged = " {capacity}%";
          states = {
            critical = 20;
            good = 95;
            warning = 30;
          };
        };
        network = {
          format-alt = "<span color='#00FFFF'> 󰤨  </span>{signalStrength}% ";
          format-disconnected = "<span color='#FF4040'>   </span>Disconnected ";
          format-ethernet = "<span color='#7FFF00'>  </span>Wired ";
          format-linked = "<span color='#FFA500'> 󱘖  </span>{ifname} (No IP) ";
          format-wifi = "<span color='#00FFFF'> 󰤨  </span>{essid} ";
          interval = 1;
          tooltip-format = "<span color='#FF1493'> 󰅧 </span>{bandwidthUpBytes}  <span color='#00BFFF'> 󰅢 </span>{bandwidthDownBytes}";
        };
      };
    };
  };
}
