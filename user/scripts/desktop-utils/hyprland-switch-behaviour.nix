# https://github.com/hyprwm/Hyprland/issues/1754#issue-1618824532
{ writeShellApplication, ... }:
let
  monitorString = "eDP-1,1920x1080@60,0x0,1";
  monitorName = "eDP-1";
in
writeShellApplication {
  name = "lid-switch-behaviour";
  text = ''
    if grep open /proc/acpi/button/lid/LID0/state; then
        hyprctl keyword monitor ${monitorString}
    else
        if [[ $(hyprctl monitors | grep -c "Monitor") != 1 ]]; then
            hyprctl keyword monitor "${monitorName}, disable"
        fi
    fi
  '';
}
