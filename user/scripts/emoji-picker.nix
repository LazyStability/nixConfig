# Original File: https://github.com/end-4/dots-hyprland/blob/e9e7b74c1b39271825aacd5fe9c43e43c5b9d958/.local/bin/fuzzel-emoji
# This file is licensed under GPL-3.0 by end-4
/*
    Copyright (C) 2023 end-4

    This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/

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
