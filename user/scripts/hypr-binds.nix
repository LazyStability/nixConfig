{
  lib,
  jq,
  pkgs,
  config,
  writeShellScriptBin,
  cmdcolor ? "cyan",
  modkeyStyle ? "<b>$MOD$KEY</b> <i>$DESCRIPTION</i>",
  dispatch ? true,
}:
let
  modmasks = {
    "0" = "";
    "1" = "SHIFT+";
    "4" = "CTRL+";
    "5" = "SHIFT+CTRL+";
    "8" = "ALT+";
    "64" = "SUPER+";
    "65" = "SUPER+SHIFT+";
    "68" = "SUPER+CTRL+";
  };
  keycodes = {
    "59" = "Comma";
    "60" = "Dot";
  };

  launcherCommand =
    if config.programs.fuzzel.enable then
      "fuzzel --match-mode fzf --dmenu --width 100 -p 'Hypr binds'"
    else if config.programs.wofi.enable then
      "wofi --matching fuzzy --dmenu -i -p 'Hypr binds'"
    else
      builtins.throw "No supported applauncher actived. Use programs.wofi.enable or programs.fuzzel.enable.";
  style =
    let
      modkey =
        builtins.replaceStrings
          [ "$MOD" "$KEY" "$DESCRIPTION" ]
          [ "\\(.mod)" "\\(if .key == \"\" then .code else .key end)" "\\(.desc)" ]
          modkeyStyle;
    in
    ''${modkey} <span color=\"${cmdcolor}\">\(.dp) \(.arg)</span>'';
in
writeShellScriptBin "hypr-binds" ''
  hyprctl binds -j |
    ${lib.getExe jq} -r '
      map({mod:.modmask|tostring,key:.key,code:.keycode|tostring,desc:.description,dp:.dispatcher,arg:.arg,sub:.submap}) |
      map(.mod |= ${builtins.toJSON modmasks} [.]) |
      map(.code |= ${builtins.toJSON keycodes} [.]) |
      sort_by(.mod) | .[] |
      select(.sub == "") |
      "${style}" ' | ${launcherCommand} |
    # extract the command (dispatcher + arg)
    sed -n 's/.*<span color=\"${cmdcolor}\">\(.*\)<\/span>.*/\1/p' |
    ${
      if dispatch then
        ''
          # add double quotes to the string so it can be piped to hyprctl dispatch
          sed -e 's/^/"/g' -e 's/$/"/g' |
          xargs -n1 hyprctl dispatch
        ''
      else
        "xargs"
    }
''
