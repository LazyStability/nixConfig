{ ... }:
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        modules-left = [
          "cpu"
          "memory"
          "hyprland/submap"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "privacy"
          "mpris"
          "wlr/taskbar"
          "temperature"
        ];

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
        mpris = {
          player = "mpv";
          format = "DEFAULT: {player_icon} {dynamic}";
          format-paused = "DEFAULT: {status_icon} <i>{dynamic}</i>";
          player-icons = {
            default = "▶";
            mpv = "🎵";
          };
          status-icons = {
            paused = "⏸";
          };
          ignored-players = [ "firefox" ];
        };
      };
    };
  };
}
