# Credit to Luke Smith
# https://github.com/LukeSmithxyz/voidrice/blob/ed9633da3f876b6c9dae13434fb7ea30208a5b5f/.local/bin/linkhandler
{
  config,
  writeShellApplication,
  pkgs,
  ...
}:
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
  ];
  text =
    let
      terminal =
        if config.programs.kitty.enable then
          "kitty"
        else if config.programs.wezterm.enable then
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
      		setsid -f mpv -quiet "$url" >/dev/null 2>&1 ;;
      	*png|*jpg|*jpe|*jpeg|*gif|*webp)
      		([ -f "$url" ] && nsxiv -a "$url" >/dev/null 2>&1) || (curl -sL "$url" > "/tmp/$(echo "$url" | sed "s/.*\///;s/%20/ /g")" && nsxiv -a "/tmp/$(echo "$url" | sed "s/.*\///;s/%20/ /g")"  >/dev/null 2>&1 &) ;;
      	*pdf|*cbz|*cbr)
      		([ -f "$url" ] && zathura "$url" >/dev/null 2>&1) || (curl -sL "$url" > "/tmp/$(echo "$url" | sed "s/.*\///;s/%20/ /g")" && zathura "/tmp/$(echo "$url" | sed "s/.*\///;s/%20/ /g")"  >/dev/null 2>&1 &) ;;
      	*mp3|*flac|*opus|*mp3?source*)
      		([ -f "$url" ] && setsid -f mpv -quiet "$url" >/dev/null 2>&1) || qndl "$url" 'curl -LO'  >/dev/null 2>&1 ;;
      	*)
      		([ -f "$url" ] && setsid -f ${terminal} -e "$EDITOR" "$url" >/dev/null 2>&1) || setsid -f xdg-open "$url" >/dev/null 2>&1
      esac
    '';
}
