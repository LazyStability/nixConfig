# Credit to Luke Smith
# https://github.com/LukeSmithxyz/voidrice/blob/ed9633da3f876b6c9dae13434fb7ea30208a5b5f/.local/bin/linkhandler
{
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

  name = "rssadd";
  runtimeInputs = [
    pkgs.wl-clipboard
    pkgs.curl
  ];
  text = ''
    if echo "$1" | grep -q "https*://\S\+\.[A-Za-z]\+\S*" ; then
            url="$1"
    else
            url="$(grep -Eom1 '<[^>]+(rel="self"|application/[a-z]+\+xml)[^>]+>' "$1" |
                    grep -o "https?://[^\" ]")"

            echo "$url" | grep -q "https*://\S\+\.[A-Za-z]\+\S*" ||
                    notify-send "That doesn't look like a full URL." && exit 1
    fi

    RSSFILE="''${XDG_CONFIG_HOME:-$HOME}/.newsboat/urls"
    if awk '{print $1}' "$RSSFILE" | grep "^$url$" >/dev/null; then
            notify-send "You already have this RSS feed."
    else
            echo "$url" >> "$RSSFILE" && notify-send "RSS feed added."
    fi
  '';
}
