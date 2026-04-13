{
  writeShellApplication,
  ...
}:

let
  applauncher =
    # if config.programs.fuzzel.enable then
    if true then
      "fuzzel --match-mode fzf --dmenu"
    # else if config.programs.wofi.enable then
    else if false then
      "wofi --matching fuzzy --dmenu"
    else
      builtins.throw "No supported applauncher actived. Use programs.wofi.enable or programs.fuzzel.enable.";
in
writeShellApplication

  {
    name = "hyprland-move-workspace-to-monitor";
    text = ''
      SWITCH_TO_MONITOR=$(hyprctl monitors -j | jq '.[] | .name'  | sed 's/"//g'| ${applauncher})
      hyprctl dispatch movecurrentworkspacetomonitor "$SWITCH_TO_MONITOR"
    '';
  }
