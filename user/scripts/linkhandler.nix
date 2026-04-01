# Original File: https://github.com/LukeSmithxyz/voidrice/blob/ed9633da3f876b6c9dae13434fb7ea30208a5b5f/.local/bin/linkhandler
# This file is licensed under GPL-3.0 by Luke Smith
/*
    Copyright (C) 2018 Luke Smith

    This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.

    This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along with this program. If not, see https://www.gnu.org/licenses/.
*/
{
  writeShellApplication,
  pkgs,
  ...
}:
let
  mpv-wrapper = writeShellApplication {
    name = "mpv-wrapper";
    text = ''
      mpv -quiet "$1" >/dev/null 2>&1 || notify-send "ERROR: mpv cannot play this file"
    '';
  };
in
writeShellApplication {

  # Feed script a url or file location.
  # If an image, it will view in sxiv,
  # if a video or gif, it will view in mpv
  # if a music file or pdf, it will download,
  # otherwise it opens link in browser.

  name = "linkhandler";
  runtimeInputs = [
    pkgs.wl-clipboard
    pkgs.curl
    pkgs.zathura
    pkgs.nsxiv
    mpv-wrapper
  ];
  text =
    let
      terminal =
        if true then
          "kitty"
        # else if config.programs.wezterm.enable then
        else if false then
          "wezterm"
        else

          builtins.throw
            "No supported terminal active. Use programs.kitty.enable or programs.wezterm.enable.";

    in
    ''

      if [ -z "''${1-}" ]; then
      	url="$(wl-paste)"
      else
      	url="$1"
      fi

      case "$url" in
      	*mkv|*webm|*mp4|*youtube.com/watch*|*youtube.com/playlist*|*youtube.com/shorts*|*youtu.be*|*hooktube.com*|*bitchute.com*|*videos.lukesmith.xyz*|*odysee.com*)
      		setsid -f mpv-wrapper "$url" ;;
      	*png|*jpg|*jpe|*jpeg|*gif|*webp)
      		([ -f "$url" ] && nsxiv -a "$url" >/dev/null 2>&1) || (curl -sL "$url" > "/tmp/$(echo "$url" | sed "s/.*\///;s/%20/ /g")" && nsxiv -a "/tmp/$(echo "$url" | sed "s/.*\///;s/%20/ /g")"  >/dev/null 2>&1 &) ;;
      	*pdf|*cbz|*cbr)
      		([ -f "$url" ] && zathura "$url" >/dev/null 2>&1) || (curl -sL "$url" > "/tmp/$(echo "$url" | sed "s/.*\///;s/%20/ /g")" && zathura "/tmp/$(echo "$url" | sed "s/.*\///;s/%20/ /g")"  >/dev/null 2>&1 &) ;;
      	*mp3|*flac|*opus|*mp3?source*)
      		([ -f "$url" ] && setsid -f mpv-wrapper "$url" ) || qndl "$url" 'curl -LO'  >/dev/null 2>&1 ;;
      	*)
      		([ -f "$url" ] && setsid -f ${terminal} -e "$EDITOR" "$url" >/dev/null 2>&1) || setsid -f xdg-open "$url" >/dev/null 2>&1
      esac
    '';
}
