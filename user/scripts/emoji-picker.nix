# Credit to end-4
# https://github.com/end-4/dots-hyprland/blob/main/.local/bin/fuzzel-emoji
{
  writeShellApplication,
  config,
  pkgs,
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
    name = "emoji-picker";
    runtimeInputs = [
      pkgs.wtype
    ];
    text = ''
      TYPING=$(${applauncher} < ${./emoji-data.txt} | cut -d ' ' -f 1 )
      wtype -s 30 "$TYPING"
      exit
    '';
  }
