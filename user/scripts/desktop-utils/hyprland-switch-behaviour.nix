# https://github.com/hyprwm/Hyprland/issues/1754#issue-1618824532
{ writeShellApplication, config, ... }:
let
  monitor = builtins.elemAt config.desktopEnvironment.monitors 0;
  monitorString =
    monitor.name + "," + monitor.mode + "@" + monitor.rate + "," + monitor.position + "," + "1";
  monitorName = monitor.name;
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
