# Credit to Lukesmith
{ writeShellApplication, config, ... }:

let
  applauncher =
    if config.programs.fuzzel.enable then
      "fuzzel"
    else if config.programs.wofi.enable then
      "wofi"
    else
      builtins.throw "No supported applauncher actived. Use programs.wofi.enable or programs.fuzzel.enable.";
in
writeShellApplication

  {
    name = "bookmark";
    text = ''
      ydotool type "$(grep -v "^#" ~/.local/share/bookmarks/websites.txt | ${applauncher} -d -i -l 50 | cut -d " " -f1)"
    '';
  }
