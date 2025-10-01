{
  writeShellApplication,
  config,
  ...
}:

let
  applauncher =
    if config.programs.fuzzel.enable then
      "fuzzel --match-mode fzf --dmenu"
    else if config.programs.wofi.enable then
      "wofi --matching fuzzy --dmenu"
    else
      builtins.throw "No supported applauncher actived. Use programs.wofi.enable or programs.fuzzel.enable.";
in
writeShellApplication

  {
    name = "move-workspace-to-monitor";
    text = ''
      SWITCH_TO_MONITOR=$(hyprctl monitors -j | jq '.[] | .name'  | sed 's/"//g'| ${applauncher})
      hyprctl dispatch movecurrentworkspacetomonitor "$SWITCH_TO_MONITOR"
    '';
  }
