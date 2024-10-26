{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces" "hyprland/Submap"];
        modules-center = ["simpleclock"];
        modules-right = ["privacy" "mpris" "cpu" "wlr/taskbar" "temperature"];
      };
    };
  };
}
