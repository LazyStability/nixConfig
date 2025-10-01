# Original File: https://github.com/LukeSmithxyz/voidrice/blob/ed9633da3f876b6c9dae13434fb7ea30208a5b5f/.local/bin/qndl
# This file is licensed under GPL-3.0 by Luke Smith
/*
    Copyright (C) 2018 Luke Smith

    This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/
{ writeShellApplication, pkgs, ... }:
writeShellApplication {
  name = "qndl";
  runtimeInputs = [
    pkgs.yt-dlp
  ];
  text = ''
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --cmd)
          cmd="$2"
          shift
          shift
          ;;
        -p|--path)
          path="$2"
          shift
          shift
          ;;
        -*)
          echo "Unknown option $1"
          exit 1
          ;;
        *)
          url="$1"
          shift
          ;;
      esac
    done
    base="$(basename "$url")"
    currentpath=$(pwd)
    cd "''${path-$HOME/Videos}" || exit 1
    notify-send "⏳ Queuing $base..."
    [ -z "''${cmd-}" ] && cmd="yt-dlp --embed-metadata --extractor-args=youtube:player_client=mweb -ic"
    $cmd "$url" 1>/dev/null &
    cd "$currentpath" || exit 1
    wait
    notify-send "👍 $base done."
  '';
}
