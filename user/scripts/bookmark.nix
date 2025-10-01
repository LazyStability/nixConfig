# This file is licensed under GPL-3.0 by Luke Smith
/*
    Copyright (C) 2018 Luke Smith

    This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/
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
